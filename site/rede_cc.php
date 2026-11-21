<?php
/**
 * CRUD de ativos de rede - Rede Cinco Conjuntos (Londrina-PR)
 * Requer: conexao.php existente, com conexão mysqli na variável $con.
 * A tabela compartilhada é criada pelo arquivo instalar_rede.sql.
 */

ob_start();
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

require_once __DIR__ . '/conexao.php';

// Incluir o menu antes de processar operações para respeitar eventual autenticação
// já implementada nele. A autorização real deve ser validada no login/menu do site.
include __DIR__ . '/menu.php';

const REDE_FILIAL = 'cc';
const REDE_TITULO = 'Rede Cinco Conjuntos (Londrina-PR)';

function rede_h($valor): string {
    return htmlspecialchars((string)$valor, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function rede_redirect(): void {
    header('Location: ' . strtok($_SERVER['REQUEST_URI'], '?'));
    exit;
}

if (!isset($_SESSION['rede_csrf'])) {
    $_SESSION['rede_csrf'] = bin2hex(random_bytes(32));
}
$csrf = $_SESSION['rede_csrf'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $token = $_POST['csrf_token'] ?? '';
    if (!is_string($token) || !hash_equals($csrf, $token)) {
        http_response_code(403);
        exit('Solicitação inválida. Atualize a página e tente novamente.');
    }

    $acao = $_POST['acao'] ?? '';

    try {
        if ($acao === 'salvar') {
            $id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT) ?: 0;
            $host = trim((string)($_POST['host'] ?? ''));
            $ip = trim((string)($_POST['ip'] ?? ''));
            $mac = trim((string)($_POST['mac'] ?? ''));

            if ($host === '' || $ip === '') {
                throw new RuntimeException('HOST e IP são obrigatórios.');
            }
            if (mb_strlen($host) > 180 || mb_strlen($ip) > 80 || mb_strlen($mac) > 120) {
                throw new RuntimeException('Um dos campos excede o tamanho permitido.');
            }

            if ($id > 0) {
                $stmt = $con->prepare(
                    'UPDATE rede_filiais
                     SET host = ?, ip = ?, mac = ?
                     WHERE id = ? AND filial = ?'
                );
                $stmt->bind_param('sssis', $host, $ip, $mac, $id, $filial);
                $filial = REDE_FILIAL;
                $stmt->execute();
                $stmt->close();
                $_SESSION['rede_flash'] = ['tipo' => 'success', 'texto' => 'Equipamento atualizado com sucesso.'];
            } else {
                $filial = REDE_FILIAL;
                $stmt = $con->prepare(
                    'INSERT INTO rede_filiais (filial, host, ip, mac)
                     VALUES (?, ?, ?, ?)'
                );
                $stmt->bind_param('ssss', $filial, $host, $ip, $mac);
                $stmt->execute();
                $stmt->close();
                $_SESSION['rede_flash'] = ['tipo' => 'success', 'texto' => 'Equipamento cadastrado com sucesso.'];
            }
            rede_redirect();
        }

        if ($acao === 'excluir') {
            $id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT);
            if (!$id || $id < 1) {
                throw new RuntimeException('Registro inválido.');
            }
            $filial = REDE_FILIAL;
            $stmt = $con->prepare('DELETE FROM rede_filiais WHERE id = ? AND filial = ?');
            $stmt->bind_param('is', $id, $filial);
            $stmt->execute();
            $stmt->close();
            $_SESSION['rede_flash'] = ['tipo' => 'success', 'texto' => 'Equipamento excluído com sucesso.'];
            rede_redirect();
        }
    } catch (Throwable $e) {
        error_log('[CRUD REDE cc] ' . $e->getMessage());
        $_SESSION['rede_flash'] = [
            'tipo' => 'danger',
            'texto' => ($e instanceof RuntimeException)
                ? $e->getMessage()
                : 'Não foi possível concluir a operação. Consulte o log do servidor.'
        ];
        rede_redirect();
    }
}

// Exportação CSV compatível com Excel (UTF-8 BOM e separador ;)
if (($_GET['exportar'] ?? '') === 'excel') {
    $filial = REDE_FILIAL;
    $stmt = $con->prepare(
        'SELECT host, ip, mac FROM rede_filiais
         WHERE filial = ? ORDER BY ip, host'
    );
    $stmt->bind_param('s', $filial);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if (ob_get_level() > 0) { ob_clean(); }
    header('Content-Type: text/csv; charset=UTF-8');
    header('Content-Disposition: attachment; filename="rede_cc.csv"');
    header('X-Content-Type-Options: nosniff');

    $saida = fopen('php://output', 'w');
    fwrite($saida, "\xEF\xBB\xBF");
    fputcsv($saida, ['HOST', 'IP', 'MAC'], ';', '"', '\\');

    while ($linha = $resultado->fetch_assoc()) {
        $campos = [];
        foreach (['host', 'ip', 'mac'] as $campo) {
            $valor = (string)$linha[$campo];
            // Evita que valores iniciados por fórmula sejam executados pelo Excel.
            if ($valor !== '' && preg_match('/^[=+\-@\\t\\r]/', $valor)) {
                $valor = "'" . $valor;
            }
            $campos[] = $valor;
        }
        fputcsv($saida, $campos, ';', '"', '\\');
    }
    fclose($saida);
    $stmt->close();
    exit;
}

// Edição
$editar = null;
if (isset($_GET['editar'])) {
    $id = filter_input(INPUT_GET, 'editar', FILTER_VALIDATE_INT);
    if ($id && $id > 0) {
        $filial = REDE_FILIAL;
        $stmt = $con->prepare('SELECT id, host, ip, mac FROM rede_filiais WHERE id = ? AND filial = ?');
        $stmt->bind_param('is', $id, $filial);
        $stmt->execute();
        $editar = $stmt->get_result()->fetch_assoc() ?: null;
        $stmt->close();
    }
}

// Pesquisa e listagem
$busca = trim((string)($_GET['busca'] ?? ''));
$filial = REDE_FILIAL;
if ($busca !== '') {
    $termo = '%' . $busca . '%';
    $stmt = $con->prepare(
        'SELECT id, host, ip, mac FROM rede_filiais
         WHERE filial = ? AND (host LIKE ? OR ip LIKE ? OR mac LIKE ?)
         ORDER BY ip, host'
    );
    $stmt->bind_param('ssss', $filial, $termo, $termo, $termo);
} else {
    $stmt = $con->prepare(
        'SELECT id, host, ip, mac FROM rede_filiais
         WHERE filial = ? ORDER BY ip, host'
    );
    $stmt->bind_param('s', $filial);
}
$stmt->execute();
$resultado = $stmt->get_result();
$equipamentos = $resultado->fetch_all(MYSQLI_ASSOC);
$stmt->close();

$flash = $_SESSION['rede_flash'] ?? null;
unset($_SESSION['rede_flash']);
?>

<div class="content" id="content">
    <h2><?= rede_h(REDE_TITULO) ?></h2>

    <style>
        .rede-toolbar{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:18px}
        .rede-actions{display:flex;gap:7px;flex-wrap:wrap}
        .rede-btn{display:inline-block;padding:9px 14px;border:0;border-radius:5px;text-decoration:none;cursor:pointer;font-size:14px;line-height:1.3}
        .rede-primary{background:#198754;color:#fff}
        .rede-secondary{background:#0d6efd;color:#fff}
        .rede-danger{background:#dc3545;color:#fff}
        .rede-muted{background:#6c757d;color:#fff}
        .rede-form{background:#fff;padding:18px;border:1px solid #ddd;border-radius:6px;margin:16px 0}
        .rede-form label{display:block;font-weight:600;margin:8px 0 5px}
        .rede-form input{width:100%;padding:10px;border:1px solid #ccc;border-radius:4px;box-sizing:border-box}
        .rede-grid{display:grid;grid-template-columns:2fr 1fr 1fr;gap:12px}
        .rede-table-wrap{overflow-x:auto}
        .rede-table{width:100%;border-collapse:collapse}
        .rede-table th{background:#FF8C00;color:#000;padding:10px;text-align:center}
        .rede-table td{padding:9px;border:1px solid #ddd;text-align:center}
        .rede-table tbody tr:hover{background:#F5DEB3;color:#000}
        .rede-alert{padding:12px;border-radius:5px;margin:12px 0}
        .rede-success{background:#d1e7dd;color:#0f5132}
        .rede-error{background:#f8d7da;color:#842029}
        .rede-search{display:flex;gap:7px;flex-wrap:wrap}
        .rede-search input{padding:9px;border:1px solid #ccc;border-radius:5px;min-width:220px}
        @media(max-width:700px){.rede-grid{grid-template-columns:1fr}.rede-search input{min-width:0;flex:1}.rede-toolbar{align-items:stretch}}
    
.card label { color: #4A4A4A !important; font-weight: 600; }

.card label, .card h3, .card h4 { color: #4A4A4A !important; font-weight: 600; }
</style>

    <?php if ($flash): ?>
        <div class="rede-alert <?= ($flash['tipo'] ?? '') === 'success' ? 'rede-success' : 'rede-error' ?>">
            <?= rede_h($flash['texto'] ?? '') ?>
        </div>
    <?php endif; ?>

    <div class="card">
        <div class="rede-toolbar">
            <div class="rede-actions">
                <a class="rede-btn rede-primary" href="#form-rede">+ Novo equipamento</a>
                <a class="rede-btn rede-secondary" href="?exportar=excel">Exportar Excel</a>
            </div>

            <form method="get" class="rede-search">
                <input type="search" name="busca" value="<?= rede_h($busca) ?>"
                       placeholder="Pesquisar HOST, IP ou MAC">
                <button class="rede-btn rede-secondary" type="submit">Pesquisar</button>
                <?php if ($busca !== ''): ?>
                    <a class="rede-btn rede-muted" href="<?= rede_h(strtok($_SERVER['REQUEST_URI'], '?')) ?>">Limpar</a>
                <?php endif; ?>
            </form>
        </div>

        <section class="rede-form" id="form-rede">
            <h3><?= $editar ? 'Editar equipamento' : 'Cadastrar equipamento' ?></h3>
            <form method="post" autocomplete="off">
                <input type="hidden" name="csrf_token" value="<?= rede_h($csrf) ?>">
                <input type="hidden" name="acao" value="salvar">
                <input type="hidden" name="id" value="<?= (int)($editar['id'] ?? 0) ?>">

                <div class="rede-grid">
                    <div>
                        <label for="rede-host">HOST *</label>
                        <input id="rede-host" name="host" maxlength="180" required
                               value="<?= rede_h($editar['host'] ?? '') ?>">
                    </div>
                    <div>
                        <label for="rede-ip">IP *</label>
                        <input id="rede-ip" name="ip" maxlength="80" required
                               placeholder="IP, DHCP ou faixa"
                               value="<?= rede_h($editar['ip'] ?? '') ?>">
                    </div>
                    <div>
                        <label for="rede-mac">MAC</label>
                        <input id="rede-mac" name="mac" maxlength="120"
                               value="<?= rede_h($editar['mac'] ?? '') ?>">
                    </div>
                </div>

                <div class="rede-actions" style="margin-top:14px">
                    <button class="rede-btn rede-primary" type="submit">
                        <?= $editar ? 'Salvar alterações' : 'Cadastrar equipamento' ?>
                    </button>
                    <?php if ($editar): ?>
                        <a class="rede-btn rede-muted" href="<?= rede_h(strtok($_SERVER['REQUEST_URI'], '?')) ?>">Cancelar</a>
                    <?php endif; ?>
                </div>
            </form>
        </section>

        <div class="rede-table-wrap">
            <table class="rede-table">
                <thead>
                    <tr><th>HOST</th><th>IP</th><th>MAC</th><th>AÇÕES</th></tr>
                </thead>
                <tbody>
                <?php if (!$equipamentos): ?>
                    <tr><td colspan="4">Nenhum equipamento encontrado.</td></tr>
                <?php else: ?>
                    <?php foreach ($equipamentos as $equipamento): ?>
                        <tr>
                            <td><?= rede_h($equipamento['host']) ?></td>
                            <td><?= rede_h($equipamento['ip']) ?></td>
                            <td><?= rede_h($equipamento['mac']) ?></td>
                            <td>
                                <div class="rede-actions" style="justify-content:center">
                                    <a class="rede-btn rede-secondary"
                                       href="?editar=<?= (int)$equipamento['id'] ?>#form-rede">Editar</a>
                                    <form method="post" onsubmit="return confirm('Confirma a exclusão deste equipamento?');">
                                        <input type="hidden" name="csrf_token" value="<?= rede_h($csrf) ?>">
                                        <input type="hidden" name="acao" value="excluir">
                                        <input type="hidden" name="id" value="<?= (int)$equipamento['id'] ?>">
                                        <button class="rede-btn rede-danger" type="submit">Excluir</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php endif; ?>
                </tbody>
            </table>
        </div>

        <p style="margin-top:14px"><strong>Total:</strong> <?= count($equipamentos) ?> equipamento(s)</p>
    </div>
</div>

<script src="script.js"></script>
</body>
</html>
