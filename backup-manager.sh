#!/usr/bin/env bash
# TodimoTi - Backup Manager
# Deixe este arquivo na raiz do projeto, junto ao docker-compose.yml.
# Os backups serão gravados em ./backup e não devem ser enviados ao Git.

set -Eeuo pipefail
umask 077

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$PROJECT_DIR/backup}"
DB_SERVICE="${DB_SERVICE:-mariadb}"

cd "$PROJECT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERRO: Docker não está instalado ou não está no PATH."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "ERRO: Docker Compose não está disponível."
  exit 1
fi

if [[ ! -f "$PROJECT_DIR/docker-compose.yml" && ! -f "$PROJECT_DIR/compose.yml" && ! -f "$PROJECT_DIR/compose.yaml" ]]; then
  echo "ERRO: arquivo Docker Compose não encontrado em $PROJECT_DIR"
  exit 1
fi

if ! docker compose config --services | grep -Fxq "$DB_SERVICE"; then
  echo "ERRO: serviço '$DB_SERVICE' não encontrado no Docker Compose."
  echo "Serviços disponíveis:"
  docker compose config --services
  exit 1
fi

mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"

pause() {
  echo
  read -r -p "ENTER para voltar ao menu..." _
}

header() {
  clear 2>/dev/null || true
  echo "======================================================"
  echo "             TODIMOTI - BACKUP DO BANCO"
  echo "======================================================"
  printf "Projeto       : %s\n" "$PROJECT_DIR"
  printf "Serviço MariaDB: %s\n" "$DB_SERVICE"
  printf "Pasta backup  : %s\n" "$BACKUP_DIR"
  echo "------------------------------------------------------"
}

check_db_container() {
  local running
  running="$(docker compose ps --status running --services 2>/dev/null || true)"
  if ! grep -Fxq "$DB_SERVICE" <<< "$running"; then
    echo "ERRO: o serviço '$DB_SERVICE' não está em execução."
    echo "Confira com: docker compose ps"
    return 1
  fi

  if ! docker compose exec -T "$DB_SERVICE" sh -lc \
    '[ -n "${MYSQL_DATABASE:-}" ] && [ -n "${MYSQL_ROOT_PASSWORD:-}" ]'; then
    echo "ERRO: MYSQL_DATABASE ou MYSQL_ROOT_PASSWORD não está disponível no container."
    echo "Confira as variáveis no docker-compose.yml/.env."
    return 1
  fi
}

create_backup() {
  local compression="${1:-gzip}"
  check_db_container || return 1

  local stamp extension file tmp
  stamp="$(date '+%Y%m%d_%H%M%S')"
  if [[ "$compression" == "gzip" ]]; then
    extension="sql.gz"
  elif [[ "$compression" == "plain" ]]; then
    extension="sql"
  else
    echo "ERRO: tipo de backup desconhecido."
    return 1
  fi

  file="$BACKUP_DIR/todimoti_${stamp}.${extension}"
  tmp="${file}.tmp"

  if [[ "$compression" == "gzip" ]]; then
    echo "Gerando backup COMPACTADO..."
  else
    echo "Gerando backup SEM COMPACTAÇÃO..."
  fi
  echo "Destino: $file"

  if [[ "$compression" == "gzip" ]]; then
    if ! docker compose exec -T "$DB_SERVICE" sh -lc '
      set -eu
      : "${MYSQL_DATABASE:?MYSQL_DATABASE não definida}"
      : "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD não definida}"
      exec mariadb-dump \
        --user=root \
        --password="$MYSQL_ROOT_PASSWORD" \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --hex-blob \
        --databases "$MYSQL_DATABASE"
    ' | gzip -c > "$tmp"; then
      rm -f "$tmp"
      echo "ERRO: falha ao gerar o dump."
      return 1
    fi

    if [[ ! -s "$tmp" ]] || ! gzip -t "$tmp"; then
      rm -f "$tmp"
      echo "ERRO: o backup está vazio ou inválido."
      return 1
    fi
  else
    if ! docker compose exec -T "$DB_SERVICE" sh -lc '
      set -eu
      : "${MYSQL_DATABASE:?MYSQL_DATABASE não definida}"
      : "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD não definida}"
      exec mariadb-dump \
        --user=root \
        --password="$MYSQL_ROOT_PASSWORD" \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --hex-blob \
        --databases "$MYSQL_DATABASE"
    ' > "$tmp"; then
      rm -f "$tmp"
      echo "ERRO: falha ao gerar o dump."
      return 1
    fi

    if [[ ! -s "$tmp" ]] || ! grep -q 'Dump completed' "$tmp"; then
      rm -f "$tmp"
      echo "ERRO: o backup está vazio ou não foi finalizado corretamente."
      return 1
    fi
  fi

  mv -- "$tmp" "$file"
  chmod 600 "$file"
  echo
  echo "BACKUP CONCLUÍDO!"
  ls -lh -- "$file"
}

list_backups() {
  echo "===== BACKUPS DISPONÍVEIS ====="
  local files=() f
  while IFS= read -r -d '' f; do files+=("$f"); done < <(
    find "$BACKUP_DIR" -maxdepth 1 -type f \
      \( -name 'todimoti_*.sql.gz' -o -name 'todimoti_*.sql' \) -print0 | sort -z
  )

  if (( ${#files[@]} == 0 )); then
    echo "Nenhum backup encontrado."
    return 0
  fi

  local i=1 tipo
  for f in "${files[@]}"; do
    if [[ "$f" == *.sql.gz ]]; then tipo="compactado"; else tipo="sem compactação"; fi
    printf "%2d) %s [%s] (%s)\n" "$i" "$(basename "$f")" "$tipo" "$(du -h -- "$f" | cut -f1)"
    ((i+=1))
  done
  printf "\nTotal: %d backup(s)\n" "${#files[@]}"
}

restore_backup() {
  check_db_container || return 1

  local files=() f i choice selected
  while IFS= read -r -d '' f; do files+=("$f"); done < <(
    find "$BACKUP_DIR" -maxdepth 1 -type f \
      \( -name 'todimoti_*.sql.gz' -o -name 'todimoti_*.sql' \) -print0 | sort -zr
  )

  if (( ${#files[@]} == 0 )); then
    echo "Nenhum backup disponível para restauração."
    return 1
  fi

  echo "===== SELECIONE O BACKUP ====="
  for i in "${!files[@]}"; do
    printf "%2d) %s (%s)\n" "$((i+1))" "$(basename "${files[$i]}")" "$(du -h -- "${files[$i]}" | cut -f1)"
  done
  echo
  read -r -p "Número do backup: " choice

  if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#files[@]} )); then
    echo "Seleção inválida."
    return 1
  fi

  selected="${files[$((choice-1))]}"
  if [[ "$selected" == *.sql.gz ]]; then
    if ! gzip -t "$selected"; then
      echo "ERRO: arquivo de backup compactado inválido/corrompido."
      return 1
    fi
  elif [[ ! -s "$selected" ]] || ! grep -q 'Dump completed' "$selected"; then
    echo "ERRO: arquivo de backup vazio ou não finalizado corretamente."
    return 1
  fi

  echo
  echo "ATENÇÃO: a restauração substitui os dados atuais do banco."
  echo "Backup selecionado: $(basename "$selected")"
  read -r -p "Para confirmar, digite RESTAURAR: " confirm
  if [[ "$confirm" != "RESTAURAR" ]]; then
    echo "Restauração cancelada."
    return 0
  fi

  echo "Restaurando banco..."
  if [[ "$selected" == *.sql.gz ]]; then
    if gzip -dc -- "$selected" | docker compose exec -T "$DB_SERVICE" sh -lc '
      set -eu
      : "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD não definida}"
      exec mariadb --user=root --password="$MYSQL_ROOT_PASSWORD"
    '; then
      echo "RESTAURAÇÃO CONCLUÍDA."
    else
      echo "ERRO: falha durante a restauração. Confira os logs do MariaDB."
      return 1
    fi
  else
    if docker compose exec -T "$DB_SERVICE" sh -lc '
      set -eu
      : "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD não definida}"
      exec mariadb --user=root --password="$MYSQL_ROOT_PASSWORD"
    ' < "$selected"; then
      echo "RESTAURAÇÃO CONCLUÍDA."
    else
      echo "ERRO: falha durante a restauração. Confira os logs do MariaDB."
      return 1
    fi
  fi
}

while true; do
  header
  cat <<'MENU'
  1) Gerar backup COMPACTADO (.sql.gz)
  2) Gerar backup SEM COMPACTAÇÃO (.sql)
  3) Listar backups disponíveis
  4) Restaurar um backup
  0) Sair

MENU
  read -r -p "Opção: " option

  case "$option" in
    1) create_backup gzip || true; pause ;;
    2) create_backup plain || true; pause ;;
    3) list_backups; pause ;;
    4) restore_backup || true; pause ;;
    0) echo "Encerrado."; exit 0 ;;
    *) echo "Opção inválida."; pause ;;
  esac
done
