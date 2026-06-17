@echo off

echo Iniciando MySQL...
docker compose down -v
docker compose up -d mysql
echo MySQL Online.

timeout /t 2 /nobreak >nul
echo Iniciando Migration...
timeout /t 8 /nobreak >nul


docker compose run --rm flyway migrate

echo Migration concluído.

pause