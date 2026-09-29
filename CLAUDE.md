# Reporte Rocas del Águila — contexto para Claude

Proyecto inmobiliario Rocas del Águila (Tasco). Este folder contiene el reporte de avance de obra para el Directorio, publicado en GitHub Pages.

## Archivos
- `Rocas_del_Aguila_Avance_Obra.html` — el reporte. Archivo único autocontenido: Chart.js inline y todos los datos en un JSON embebido `const DATA = {...}` dentro del `<script>`. **Editar este archivo directamente.**
- `index.html` — copia del reporte que sirve GitHub Pages. No editar a mano: `auto_push.bat` lo regenera.
- `METODOLOGIA.md` — bitácora de criterios y supuestos del modelo (§7b gastos financieros, §7c sensibilidad, §7d pagarés proyectados, §7e tasas v3, §8 cuadro maestro). **Actualizarla en cada cambio de criterio.**
- `IG_Rocas del Águila.xlsx` — fuente principal (hoja "3.FlujodeCaja_Consolidado"). Filas clave: 19 Edificación, 28 Costos Financieros (total −15.770,18 UF), 58 Préstamos Bancarios, 59 Amortizaciones Préstamos Bancos, 60 Saldo Final Deuda Financiera. Columnas: F Presupuesto, G Real a la fecha, H Proyección, I Total, mensual desde K.
- `.gitignore` — excluye xlsx/pdf/log: los datos fuente nunca se suben a GitHub.

## Cómo editar el reporte
- Datos: cargar el JSON de `DATA` (buscar `const DATA = ` y parsear con `json.JSONDecoder().raw_decode`), modificar y volver a serializar con `ensure_ascii=False`.
- Textos/KPIs estáticos y JS: edición directa del HTML.
- Verificar después de cada cambio: el JSON parsea y `node --check` sobre el `<script>` final no da errores.
- Formato de números: estilo chileno (miles con punto, decimales con coma), valores en UF.

## Modelo de gastos financieros (criterio vigente, v3)
- Cada pagaré real paga su **1er período con tasa y plazo contractual**; después se renueva cada 12 meses a **tasa tipo 5% fijo**.
- Pagarés proyectados (pedidas oct-26 a oct-27, fila 58 del flujo de caja): **anuales al 5%**. Giro sept-26 (pagaré pendiente): 1er año 4,14%, luego 5%.
- Pago de capital: 3 cuotas a fin de mes desde la fecha de recuperación (base 29-feb-2028): 50.000 / 80.000 / resto UF, asignación FIFO por antigüedad.
- Resultado base: 12.270,9 UF. Meta del flujo de caja: 15.770 UF (calibrado ≈ jul-2028).
- Motor en JS (`sens*`, al final del script) y datos en `DATA.gastos_financieros_model`.
- Cuadro Maestro: acumulados finales fijos 198.139 UF EEPP bruto y 178.232 UF pedido banco.

## Publicar en GitHub
- Repo: https://github.com/oecerda-ux/reporte-directorio-rocas (rama `master`) → https://oecerda-ux.github.io/reporte-directorio-rocas/
- Publicar = ejecutar `auto_push.bat` (copia el reporte a index.html, commit y push). La credencial está guardada en el Administrador de Credenciales de Windows.
- Existe además la tarea programada "Watch Reporte Rocas" (`watch_push.ps1`) que publica sola si el reporte cambia; si se publica directo con `auto_push.bat`, la tarea es opcional.
- **Seguridad:** nunca pedir, aceptar ni usar tokens de GitHub en el chat ni embebidos en URLs.

## Entorno
- En este equipo no hay Python: usar Node (leer xlsx descomprimiendo con `unzip` y parseando el XML de las hojas).

## Pendiente: EEPP N°8
- Al 29-sep-2026 el reporte llega hasta el EEPP N°7 (corte 31-ago-2026, 43,63%). El EEPP N°8 (corte 30-sep-2026) aún no llega.
- Archivo esperado: `EEPP N°8 Obra Casas Rocas del Aguila Inmobiliario.xlsx` en esta carpeta. Si no está, buscar en Downloads y OneDrive\Documentos.
- No confundir con `Avance Rx del Aguila MM-2026.xlsx`: es otra serie (L0.5, alcance contrato total, numeración distinta; su hoja "Avance n° 8" es jun-26).
- Proceso: METODOLOGIA.md §10 y §11 (reajuste sigmoidal, Monte Carlo, pedidas_banco Sigmoidal, `eepp_bruto[oct-26]` a real desde "Total Proyecto" columna "Actual", textos, publicar).

## Preguntas abiertas
- EEPP bruto jul-26: 17.706 UF (EEPP N°4+N°5) vs 17.692 UF en el flujo de caja — sin resolver.
