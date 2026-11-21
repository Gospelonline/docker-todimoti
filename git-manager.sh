#!/usr/bin/env bash
# TodimoTi - Git Manager simplificado
# Instalação: deixe este arquivo na raiz do repositório e execute ./git-manager.sh

set -Eeuo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REMOTE="origin"

if ! command -v git >/dev/null 2>&1; then
  echo "ERRO: Git não está instalado."
  exit 1
fi

if [[ ! -d "$REPO_DIR/.git" ]]; then
  echo "ERRO: este script precisa ficar na raiz de um repositório Git."
  echo "Diretório verificado: $REPO_DIR"
  exit 1
fi

cd "$REPO_DIR"

pause() {
  echo
  read -r -p "ENTER para voltar ao menu..." _
}

header() {
  clear 2>/dev/null || true
  echo "======================================================"
  echo "               TODIMOTI - GIT MANAGER"
  echo "======================================================"
  printf "Projeto : %s\n" "$(basename "$REPO_DIR")"
  printf "Pasta   : %s\n" "$REPO_DIR"
  printf "Branch  : %s\n" "$(git branch --show-current)"
  printf "Remoto  : %s\n" "$REMOTE"
  echo "------------------------------------------------------"
}

status_repo() {
  echo "===== STATUS ====="
  git status -sb
  echo
  echo "===== SINCRONIZAÇÃO ====="
  local branch upstream counts
  branch="$(git branch --show-current)"
  upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"
  if [[ -n "$upstream" ]]; then
    counts="$(git rev-list --left-right --count "$branch...$upstream")"
    read -r ahead behind <<< "$counts"
    echo "À frente: $ahead commit(s) | Atrás: $behind commit(s)"
  else
    echo "Upstream não configurado para esta branch."
  fi
  echo
  echo "===== RESUMO DAS ALTERAÇÕES ====="
  git diff --stat
  git diff --cached --stat
}

sensitive_staged_check() {
  local bad=0 f
  while IFS= read -r -d '' f; do
    case "$f" in
      .env|.env.*|*.sql|*.sql.gz|*.dump|*.bak|backup/*|*/backup/*|mariadb/*|*/mariadb/*)
        printf 'BLOQUEADO: arquivo potencialmente sensível preparado: %s\n' "$f"
        bad=1
        ;;
    esac
  done < <(git diff --cached --diff-filter=ACMRTUXB --name-only -z)
  return "$bad"
}

commit_changes() {
  echo "===== COMMIT ====="
  git status --short
  echo
  read -r -p "Descrição do commit: " message
  if [[ -z "${message//[[:space:]]/}" ]]; then
    echo "Descrição vazia. Commit cancelado."
    return 1
  fi

  # Adiciona automaticamente todas as alterações respeitando o .gitignore.
  git add -A

  if git diff --cached --quiet; then
    echo "Não há alterações para registrar."
    return 0
  fi

  echo
  echo "===== ARQUIVOS INCLUÍDOS ====="
  git diff --cached --name-status
  echo

  if ! sensitive_staged_check; then
    echo
    echo "Commit cancelado para evitar publicar arquivos sensíveis."
    echo "Revise o .gitignore e os arquivos preparados."
    return 1
  fi

  git commit -m "$message"
}

push_changes() {
  echo "===== PUSH ====="
  local branch
  branch="$(git branch --show-current)"
  if [[ -z "$branch" ]]; then
    echo "Não foi possível identificar a branch."
    return 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Existem alterações locais não commitadas."
    echo "Execute Commit antes do Push."
    return 1
  fi

  if ! sensitive_staged_check; then
    echo "Push bloqueado: há arquivos sensíveis preparados."
    return 1
  fi

  if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    git push "$REMOTE" "$branch"
  else
    git push -u "$REMOTE" "$branch"
  fi
}

pull_changes() {
  echo "===== PULL ====="
  if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    echo "Pull bloqueado: existem alterações locais ou arquivos novos."
    echo "Faça Commit ou guarde suas alterações antes de atualizar."
    return 1
  fi

  local branch
  branch="$(git branch --show-current)"
  git fetch "$REMOTE"
  git pull --ff-only "$REMOTE" "$branch"
}

fetch_changes() {
  echo "===== FETCH ====="
  git fetch --prune "$REMOTE"
  echo "Atualização remota consultada. Nenhum arquivo local foi alterado."
}

show_log() {
  echo "===== ÚLTIMOS 20 COMMITS ====="
  git --no-pager log --oneline --decorate -20
}

show_diff() {
  echo "===== ALTERAÇÕES NÃO PREPARADAS ====="
  git --no-pager diff
  echo
  echo "===== ALTERAÇÕES PREPARADAS ====="
  git --no-pager diff --cached
}

show_branches() {
  echo "===== BRANCHES ====="
  git branch -vv
  echo
  read -r -p "Digite o nome da branch para trocar (ENTER mantém a atual): " branch
  if [[ -n "$branch" ]]; then
    if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
      echo "Troca bloqueada: existem alterações locais ou arquivos novos."
      return 1
    fi
    git switch "$branch"
  fi
}

while true; do
  header
  cat <<'MENU'
  1) Status
  2) Commit (informa somente a descrição)
  3) Push
  4) Pull
  5) Fetch
  6) Histórico
  7) Diff
  8) Branches
  0) Sair

MENU
  read -r -p "Opção: " option

  case "$option" in
    1) status_repo; pause ;;
    2) commit_changes || true; pause ;;
    3) push_changes || true; pause ;;
    4) pull_changes || true; pause ;;
    5) fetch_changes || true; pause ;;
    6) show_log; pause ;;
    7) show_diff; pause ;;
    8) show_branches || true; pause ;;
    0) echo "Encerrado."; exit 0 ;;
    *) echo "Opção inválida."; pause ;;
  esac
done
