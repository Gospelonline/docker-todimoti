FROM php:8.4-fpm

# Instala extensões necessárias
RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql

# Diretório da aplicação
WORKDIR /var/www/html
