<?php

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

function usuario_e_admin(): bool
{
    return (
        !empty($_SESSION['logado']) &&
        $_SESSION['logado'] === true &&
        ($_SESSION['privilegios'] ?? '') === 'admin'
    );
}

function exigir_admin(): void
{
    if (!usuario_e_admin()) {
        http_response_code(403);
        exit('Acesso negado. Somente administradores podem realizar esta operação.');
    }
}
