# ============================================================
#  Publica el reporte en GitHub cuando cambia.
#  Version 2: revisa el archivo cada 20 segundos (polling) en vez
#  de esperar avisos de Windows, que no siempre llegan cuando el
#  archivo lo escribe Claude desde su entorno.
# ============================================================
$folder = Split-Path -Parent $MyInvocation.MyCommand.Path
$bat    = Join-Path $folder "auto_push.bat"
$log    = Join-Path $folder "auto_push.log"
$src    = Join-Path $folder "Rocas_del_Aguila_Avance_Obra.html"
$idx    = Join-Path $folder "index.html"

function Get-Hash($p) { if (Test-Path $p) { (Get-FileHash $p -Algorithm SHA256).Hash } else { "" } }

"[$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')] Vigilante iniciado (polling cada 20 s)" | Out-File -Append -Encoding utf8 $log

while ($true) {
    try {
        if ((Get-Hash $src) -ne (Get-Hash $idx)) {
            # Espera a que termine de escribirse y confirma que ya no cambia
            $h1 = Get-Hash $src; Start-Sleep -Seconds 8; $h2 = Get-Hash $src
            if ($h1 -eq $h2) {
                "[$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')] Cambio detectado, publicando..." | Out-File -Append -Encoding utf8 $log
                & cmd.exe /c "`"$bat`"" 2>&1 | Out-File -Append -Encoding utf8 $log
            }
        }
    } catch {
        "[$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')] ERROR: $_" | Out-File -Append -Encoding utf8 $log
    }
    Start-Sleep -Seconds 20
}
