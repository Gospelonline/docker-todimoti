<?php
session_start();
require_once "conexao.php";

$login = trim($_POST["login"] ?? "");
$senha = $_POST["senha"] ?? "";

if ($login === "" || $senha === "") {
    $_SESSION["error"] = "Informe usuário e senha.";
    header("Location: login.php");
    exit;
}

$stmt = $con->prepare(
    "SELECT id, login, nome, privilegios, senha FROM usuarios WHERE login = ? LIMIT 1"
);
$stmt->bind_param("s", $login);
$stmt->execute();
$usuario = $stmt->get_result()->fetch_assoc();

$autenticado = false;

if ($usuario) {
    $hash = (string)$usuario["senha"];

    if (preg_match('/^[a-f0-9]{32}$/i', $hash)) {
        $autenticado = hash_equals(strtolower($hash), md5($senha));

        if ($autenticado) {
            $novoHash = password_hash($senha, PASSWORD_DEFAULT);
            $up = $con->prepare("UPDATE usuarios SET senha = ? WHERE id = ?");
            $up->bind_param("si", $novoHash, $usuario["id"]);
            $up->execute();
        }
    } else {
        $autenticado = password_verify($senha, $hash);

        if ($autenticado && password_needs_rehash($hash, PASSWORD_DEFAULT)) {
            $novoHash = password_hash($senha, PASSWORD_DEFAULT);
            $up = $con->prepare("UPDATE usuarios SET senha = ? WHERE id = ?");
            $up->bind_param("si", $novoHash, $usuario["id"]);
            $up->execute();
        }
    }
}

if ($autenticado) {
    session_regenerate_id(true);
    $_SESSION["logado"] = true;
    $_SESSION["user"] = $usuario["login"];
    $_SESSION["privilegios"] = $usuario["privilegios"];

    include "logger.php";
    Logger($login);

    header("Location: index.php");
    exit;
}

$_SESSION["error"] = "Usuário ou senha inválidos.";
header("Location: login.php");
exit;
