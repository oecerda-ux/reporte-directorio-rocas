@echo off
REM ============================================================
REM  Publica automaticamente el reporte a GitHub si hay cambios.
REM  Pensado para correr desde el Programador de Tareas de Windows.
REM ============================================================
cd /d "%~dp0"

REM Actualiza la copia que se publica (index.html) con la version actual del reporte
copy /Y "Rocas_del_Aguila_Avance_Obra.html" "index.html" >nul

git add -A

git diff --cached --quiet
if %errorlevel%==0 (
    echo Sin cambios que publicar. %date% %time%
    exit /b 0
)

git commit -m "Actualizacion automatica %date% %time%"
git push origin master

if %errorlevel%==0 (
    echo Publicado correctamente. %date% %time%
) else (
    echo ERROR al hacer push. Revisa la credencial guardada. %date% %time%
)
