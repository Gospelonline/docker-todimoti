<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
require_once "lib/permissoes.php";
exigir_admin();
require_once "conexao.php";

function usuarios_h($v): string {
    return htmlspecialchars((string)$v, ENT_QUOTES, "UTF-8");
}

if (empty($_SESSION["csrf_usuarios"])) {
    $_SESSION["csrf_usuarios"] = bin2hex(random_bytes(32));
}

$mensagem = $_SESSION["usuarios_mensagem"] ?? "";
unset($_SESSION["usuarios_mensagem"]);

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (!hash_equals($_SESSION["csrf_usuarios"], $_POST["csrf"] ?? "")) {
        http_response_code(403);
        exit("Token de segurança inválido.");
    }

    $acao = $_POST["acao"] ?? "";

    if ($acao === "salvar") {
        $id = (int)($_POST["id"] ?? 0);
        $login = trim($_POST["login"] ?? "");
        $nome = trim($_POST["nome"] ?? "");
        $perfil = $_POST["privilegios"] ?? "";
        $senha = $_POST["senha"] ?? "";
        $confirmacao = $_POST["confirmacao"] ?? "";
        $erro = "";

        if ($login === "" || $nome === "" ||
            strlen($login) > 150 || strlen($nome) > 150 ||
            !in_array($perfil, ["admin", "basic"], true)) {
            $erro = "Preencha corretamente os campos obrigatórios.";
        } elseif ($id === 0 && $senha === "") {
            $erro = "Informe uma senha para o novo usuário.";
        } elseif ($senha !== "" && strlen($senha) < 10) {
            $erro = "A senha deve ter pelo menos 10 caracteres.";
        } elseif ($senha !== $confirmacao) {
            $erro = "A confirmação da senha não confere.";
        }

        $atual = null;

        if (!$erro && $id > 0) {
            $q = $con->prepare(
                "SELECT id, login, privilegios FROM usuarios WHERE id = ?"
            );
            $q->bind_param("i", $id);
            $q->execute();
            $atual = $q->get_result()->fetch_assoc();

            if (!$atual) {
                $erro = "Usuário não encontrado.";
            }
        }

        if (!$erro && $atual &&
            $atual["privilegios"] === "admin" && $perfil !== "admin") {
            $q = $con->query(
                "SELECT COUNT(*) AS total FROM usuarios WHERE privilegios = 'admin'"
            );
            if ((int)$q->fetch_assoc()["total"] <= 1) {
                $erro = "Não é possível rebaixar o último administrador.";
            }
        }

        if ($erro) {
            $_SESSION["usuarios_mensagem"] = $erro;
        } else {
            try {
                if ($id === 0) {
                    $hash = password_hash($senha, PASSWORD_DEFAULT);
                    $q = $con->prepare(
                        "INSERT INTO usuarios (login, senha, nome, privilegios) VALUES (?, ?, ?, ?)"
                    );
                    $q->bind_param("ssss", $login, $hash, $nome, $perfil);
                    $q->execute();
                    $_SESSION["usuarios_mensagem"] = "Usuário cadastrado com sucesso.";
                } else {
                    if ($senha !== "") {
                        $hash = password_hash($senha, PASSWORD_DEFAULT);
                        $q = $con->prepare(
                            "UPDATE usuarios SET login=?, nome=?, privilegios=?, senha=? WHERE id=?"
                        );
                        $q->bind_param("ssssi", $login, $nome, $perfil, $hash, $id);
                    } else {
                        $q = $con->prepare(
                            "UPDATE usuarios SET login=?, nome=?, privilegios=? WHERE id=?"
                        );
                        $q->bind_param("sssi", $login, $nome, $perfil, $id);
                    }
                    $q->execute();

                    if (($_SESSION["user"] ?? "") === $atual["login"]) {
                        $_SESSION["user"] = $login;
                        $_SESSION["privilegios"] = $perfil;
                    }

                    $_SESSION["usuarios_mensagem"] = "Usuário atualizado com sucesso.";
                }
            } catch (mysqli_sql_exception $e) {
                $_SESSION["usuarios_mensagem"] =
                    $e->getCode() === 1062
                    ? "Este login já está cadastrado."
                    : "Erro ao salvar usuário. Verifique os dados.";
            }
        }

        header("Location: gerenciar_usuarios.php");
        exit;
    }

    if ($acao === "excluir") {
        $id = (int)($_POST["id"] ?? 0);
        $q = $con->prepare(
            "SELECT id, login, privilegios FROM usuarios WHERE id = ?"
        );
        $q->bind_param("i", $id);
        $q->execute();
        $alvo = $q->get_result()->fetch_assoc();

        if (!$alvo) {
            $_SESSION["usuarios_mensagem"] = "Usuário não encontrado.";
        } elseif ($alvo["login"] === ($_SESSION["user"] ?? "")) {
            $_SESSION["usuarios_mensagem"] = "Não é permitido excluir a própria conta.";
        } else {
            $permitir = true;

            if ($alvo["privilegios"] === "admin") {
                $q = $con->query(
                    "SELECT COUNT(*) AS total FROM usuarios WHERE privilegios = 'admin'"
                );
                if ((int)$q->fetch_assoc()["total"] <= 1) {
                    $permitir = false;
                    $_SESSION["usuarios_mensagem"] =
                        "Não é possível excluir o último administrador.";
                }
            }

            if ($permitir) {
                $q = $con->prepare("DELETE FROM usuarios WHERE id = ?");
                $q->bind_param("i", $id);
                $q->execute();
                $_SESSION["usuarios_mensagem"] = "Usuário excluído com sucesso.";
            }
        }

        header("Location: gerenciar_usuarios.php");
        exit;
    }
}

$editar = null;
$editarId = (int)($_GET["editar"] ?? 0);

if ($editarId > 0) {
    $q = $con->prepare(
        "SELECT id, login, nome, privilegios FROM usuarios WHERE id = ?"
    );
    $q->bind_param("i", $editarId);
    $q->execute();
    $editar = $q->get_result()->fetch_assoc();
}

include "menu.php";

$q = $con->query(
    "SELECT id, login, nome, privilegios FROM usuarios ORDER BY nome, login"
);
$usuarios = $q->fetch_all(MYSQLI_ASSOC);
?>

<main style="padding:25px;max-width:1100px;margin:0 auto;">
<h2>Gerenciar Usuários</h2>

<?php if ($mensagem): ?>
<p style="padding:12px;background:#e8f0fe;border-radius:6px;">
<?= usuarios_h($mensagem) ?>
</p>
<?php endif; ?>

<section style="padding:20px;border-radius:8px;margin:20px 0;background:var(--card-bg,#f5f5f5);">
<h3><?= $editar ? "Alterar usuário" : "Cadastrar usuário" ?></h3>

<form method="post" action="gerenciar_usuarios.php" autocomplete="off">
<input type="hidden" name="csrf" value="<?= usuarios_h($_SESSION["csrf_usuarios"]) ?>">
<input type="hidden" name="acao" value="salvar">
<input type="hidden" name="id" value="<?=(int)($editar["id"] ?? 0)?>">

<div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:14px;">
<label>Login
<input required maxlength="150" name="login" value="<?= usuarios_h($editar["login"] ?? "") ?>" style="display:block;width:100%;padding:10px;box-sizing:border-box;">
</label>

<label>Nome / descrição
<input required maxlength="150" name="nome" value="<?= usuarios_h($editar["nome"] ?? "") ?>" style="display:block;width:100%;padding:10px;box-sizing:border-box;">
</label>

<label>Perfil
<select name="privilegios" required style="display:block;width:100%;padding:10px;box-sizing:border-box;">
<option value="basic" <?= (($editar["privilegios"] ?? "basic")==="basic")?"selected":"" ?>>Basic - Consulta</option>
<option value="admin" <?= (($editar["privilegios"] ?? "")==="admin")?"selected":"" ?>>Admin - Gerenciamento</option>
</select>
</label>

<label>Senha <?= $editar ? "(vazia mantém a atual)" : "" ?>
<input type="password" name="senha" minlength="10" <?= $editar ? "" : "required" ?> autocomplete="new-password" style="display:block;width:100%;padding:10px;box-sizing:border-box;">
</label>

<label>Confirmar senha
<input type="password" name="confirmacao" minlength="10" <?= $editar ? "" : "required" ?> autocomplete="new-password" style="display:block;width:100%;padding:10px;box-sizing:border-box;">
</label>
</div>

<p style="margin-top:16px;">
<button type="submit"><?= $editar ? "Salvar alterações" : "Cadastrar usuário" ?></button>
<?php if ($editar): ?>
<a href="gerenciar_usuarios.php">Cancelar</a>
<?php endif; ?>
</p>
</form>
</section>


<style>
.usuarios-lista {
    margin-top: 25px;
    padding: 22px;
    background: var(--card-bg, #202020);
    border: 1px solid rgba(255,255,255,.10);
    border-radius: 10px;
    box-shadow: 0 3px 12px rgba(0,0,0,.18);
}
.usuarios-lista h3 {
    margin: 0 0 18px;
    font-size: 19px;
    font-weight: 600;
}
.usuarios-table-wrap {
    width: 100%;
    overflow-x: auto;
    border-radius: 8px;
}
.usuarios-table {
    width: 100%;
    min-width: 650px;
    border-collapse: collapse;
    font-size: 14px;
}
.usuarios-table th {
    padding: 14px 16px;
    text-align: left;
    white-space: nowrap;
    background: rgba(128,128,128,.18);
    border-bottom: 2px solid rgba(255,255,255,.15);
}
.usuarios-table td {
    padding: 13px 16px;
    text-align: left;
    vertical-align: middle;
    border-bottom: 1px solid rgba(128,128,128,.20);
}
.usuarios-table tbody tr:nth-child(even) {
    background: rgba(128,128,128,.07);
}
.usuarios-table tbody tr:hover {
    background: rgba(255,140,0,.10);
}
.usuarios-table tbody tr:last-child td {
    border-bottom: none;
}
.usuarios-table td:first-child {
    font-weight: 600;
}
.usuarios-table .perfil-admin {
    color: #ffad42;
    font-weight: 600;
}
.usuarios-table .perfil-basic {
    color: #55b9e8;
    font-weight: 600;
}
.usuarios-table a {
    display: inline-block;
    margin-right: 8px;
    color: #65aaff;
    text-decoration: none;
    font-weight: 600;
}
.usuarios-table a:hover {
    text-decoration: underline;
}
.usuarios-table form {
    display: inline-block;
    margin: 0;
}
.usuarios-table button {
    padding: 7px 12px;
    border: 0;
    border-radius: 5px;
    background: #b83c35;
    color: white;
    cursor: pointer;
    font-size: 12px;
}
.usuarios-table button:hover {
    background: #d34a42;
}
.usuarios-table .conta-atual {
    color: #999;
    font-size: 12px;
    white-space: nowrap;
}
@media (max-width: 700px) {
    .usuarios-lista { padding: 14px; }
    .usuarios-table { font-size: 13px; }
    .usuarios-table th, .usuarios-table td {
        padding: 11px 12px;
    }
}
</style>

<section class="usuarios-lista">
<h3>Usuários cadastrados</h3>
<div class="usuarios-table-wrap">
<table class="usuarios-table">
<thead><tr><th>Login</th><th>Nome / descrição</th><th>Perfil</th><th>Ações</th></tr></thead>
<tbody>
<?php foreach ($usuarios as $u): ?>
<tr>
<td><?= usuarios_h($u["login"]) ?></td>
<td><?= usuarios_h($u["nome"]) ?></td>
<td><span class="<?= $u["privilegios"] === "admin" ? "perfil-admin" : "perfil-basic" ?>"><?= $u["privilegios"] === "admin" ? "Admin" : "Basic" ?></span></td>
<td>
<a href="gerenciar_usuarios.php?editar=<?=(int)$u["id"]?>">Editar</a>
<?php if ($u["login"] !== ($_SESSION["user"] ?? "")): ?>
<form method="post" action="gerenciar_usuarios.php" style="display:inline;" onsubmit="return confirm('Confirma a exclusão deste usuário?');">
<input type="hidden" name="csrf" value="<?= usuarios_h($_SESSION["csrf_usuarios"]) ?>">
<input type="hidden" name="acao" value="excluir">
<input type="hidden" name="id" value="<?=(int)$u["id"]?>">
<button type="submit">Excluir</button>
</form>
<?php else: ?>
<span class="conta-atual">(conta atual)</span>
<?php endif; ?>
</td>
</tr>
<?php endforeach; ?>
</tbody>
</table>
</div>
</section>
</main>
