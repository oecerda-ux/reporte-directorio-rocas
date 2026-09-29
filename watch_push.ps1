# ============================================================
#  Vigila el reporte y lo publica en GitHub pocos segundos
#  despues de cada cambio (llama a auto_push.bat).
#  Se deja corriendo en segundo plano al iniciar sesion.
# ============================================================
$folder = Split-Path -Parent $MyInvocation.MyCommand.Path
$bat    = Join-Path $folder "auto_push.bat"
$log    = Join-Path $folder "auto_push.log"

$watcher = New-Object System.IO.FileSystemWatcher $folder, "Rocas_del_Aguila_Avance_Obra.html"
$watcher.NotifyFilter = [IO.NotifyFilters]'LastWrite, FileName, Size'

while ($true) {
    $r = $watcher.WaitForChanged([IO.WatcherChangeTypes]::All, 60000)
    if (-not $r.TimedOut) {
        # Espera a que terminen todas las escrituras antes de publicar
        Start-Sleep -Seconds 10
        & cmd.exe /c "`"$bat`"" 2>&1 | Out-File -Append -Encoding utf8 $log
    }
}
