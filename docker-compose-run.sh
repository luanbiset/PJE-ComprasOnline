#!/bin/bash

echo "Iniciando MySQL..."

docker compose down -v
docker compose up -d mysql

echo "MySQL Online."

sleep 2

echo "Aguardando inicialização do MySQL..."
sleep 8

echo "Iniciando Migration..."

docker compose run --rm flyway migrate

echo "Migration concluído."

read -p "Pressione Enter para continuar..."