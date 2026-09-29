# Metodología — Reporte Rocas del Águila (Avance de Obra + Avances Financieros Banco)

> Documento de contexto para retomar el trabajo sin tener que re-explicar la lógica de cada informe. Léelo antes de pedir una actualización del reporte.

---

## 1. El proyecto

- **Rocas del Águila**, desarrollo inmobiliario residencial, **Etapa 2**, en modalidad **venta en verde** (pre-venta).
- Los ingresos comerciales del proyecto son *cuotas de anticipo* sobre *promesas* — no confundir con *escrituración*. Este reporte **no** mezcla ese flujo comercial con el avance de obra/construcción.
- Meta contractual de término: **octubre 2027**.
- Todos los montos base están en **UF** (moneda contractual); los montos en pesos dependen del valor UF proyectado de cada mes.
- Contraparte constructora controlada vía **EEPP** (Estados de Pago) mensuales.

---

## 2. Estructura del contrato (corregida)

| Concepto | Neto (UF) | Bruto c/IVA 19% (UF) |
|---|---|---|
| **Contrato total** | 166.416,87 | **198.036,08** |
| Obras Previas (excavación, gastos generales) | 9.869,97 | 11.745,26 |
| Obra Casas — EEPP controlado (edificación) | 156.546,90 | 186.290,82 |

**Puntos clave:**
- **Obras Previas** (principalmente excavación) están **100% ejecutadas**, pero fueron **financiadas directamente por los socios** — nunca se giró la línea bancaria para pagarlas.
- El **EEPP que se controla mensualmente es "corto"**: mide solo la edificación (Obra Casas), **no** incluye las partidas de excavación. Por eso el avance físico reportado (ej. 30,13% a jun-26) es avance de edificación únicamente.
- A nivel de **avance físico de obra**, seguir usando el EEPP controlado tal cual — es correcto, porque son las partidas de edificación las que dan el 100% de avance de construcción.
- El problema aparece al mezclar esto con las cifras **financieras/bancarias**, porque la línea del banco se aprobó sobre el contrato **total** (incluida la excavación). Ver §5 "Avance Financiero Total".

**Nota de reconciliación:** el total "bottom-up" desde el EEPP (Costo Directo con GG + Utilidad ≈ 156.957,83 UF neto) difiere levemente (~400 UF) del total contractual corregido (166.416,87 UF neto − 9.869,97 UF obras previas = 156.546,90 UF). Se usa el **total contractual corregido** como fuente de verdad; la diferencia es inmaterial (~0,3%) y no se ha investigado a fondo.

---

## 3. Curvas de avance físico

Se llevan **4 curvas**, todas expresadas como % acumulado de avance de la edificación (EEPP controlado):

1. **Curva Estimada (Contrato)**: base contractual, origen oct-25, término oct-27 (24 meses). Valores fijos, no cambian.
2. **Curva Abril-27 (Meta)**: escenario alternativo de recepción anticipada en abril-27 (19 meses). Valores fijos.
3. **Curva Real (EEPP)**: avance efectivo reportado en cada EEPP. Se actualiza cada vez que llega un EEPP nuevo.
4. **Curva Sigmoidal**: regresión logística `Avance(t) = 1/(1+e^-k(t-t₀))` ajustada por mínimos cuadrados a los puntos reales, **renormalizada** (factor ×1,0204 con los parámetros actuales, k=0,29643, t₀=10,8676) para que llegue exactamente a **100% en oct-27** (mismo mes que la meta contractual). **Es la curva de referencia por defecto** del reporte — se usa como base para las proyecciones financieras cuando hay que elegir una curva.

### Datos reales EEPP (a re-ajustar con cada informe nuevo)

| Informe | Fecha corte | Avance acum. |
|---|---|---|
| EP N°1 | 31-dic-2025 | 4,70% |
| EP N°1 (3) | 28-feb-2026 | 12,94% |
| EEPP N°2 | 31-mar-2026 | 15,47% |
| EP N°3 | 30-abr-2026 | 18,98% |
| EP N°4 | 31-may-2026 | 23,95% |
| EEPP N°5 | 30-jun-2026 | 30,13% |
| EEPP N°6 | 31-jul-2026 | 36,17% |
| EEPP N°7 | 31-ago-2026 | 43,63% |

Fuente: columna "Avance Porcentual Acumulado" de la fila "ST Costo Directo con GG" en cada archivo EEPP (t=10 para EEPP N°7, meses desde oct-25, en la convención usada para el ajuste). Valor UF de referencia del informe EEPP N°7: 38.400.

**Al llegar un EEPP nuevo:**
1. Agregar el punto a la tabla de arriba.
2. Re-ajustar k y t₀ de la sigmoidal con los 7+ puntos (mínimos cuadrados no lineales, `scipy.optimize.curve_fit`).
3. Volver a renormalizar para que la sigmoidal llegue a 100% en oct-27 (o la fecha de término vigente).
4. Recalcular todas las tablas derivadas (financiero, financiero_uf, avance_financiero_total —incluida la extensión de `avance_financiero_total.real` al nuevo mes—, Cuadro Maestro (redistribución ago-26+), Pedidas de Flujo al Banco columna sigmoidal) que dependen de la curva sigmoidal.
5. Recalcular las probabilidades Monte Carlo (σ y simulación) con el punto nuevo.

**Nota jul-26 (EEPP N°6):** el avance real (36,17%) quedó muy cerca de la curva Contrato en ese mismo mes (36,3% esperado) — el proyecto recuperó gran parte del atraso que mostraba a jun-26 (gap de ~2,2pp) a un gap de apenas ~0,13pp. Esto explica el salto en las probabilidades de cumplimiento (ver abajo).

**Nota ago-26 (EEPP N°7):** el avance real (43,63%) quedó 0,87pp por debajo de la curva sigmoidal recién reajustada para ese mes (44,50%) — leve desviación, dentro del rango de ruido observado en meses anteriores. No cambia la conclusión de que el proyecto sigue cerca de la trayectoria esperada.

### Probabilidad de cumplir cada curva (Monte Carlo)

- 30.000 escenarios, proyectando el avance real mes a mes desde el último dato real conocido.
- Tendencia central = incrementos mensuales de la curva sigmoidal (ya ajustada, sin renormalizar el ruido).
- Ruido aleatorio ~ Normal(0, σ), con σ estimado de los residuos (avance real − avance sigmoidal esperado) de los últimos intervalos mensuales consecutivos.
- "Cumplir" una curva = alcanzar ≥98% de avance físico antes de su mes de término.
- Resultados de referencia (con los datos a ago-26, 8 informes reales, 6 intervalos consecutivos, σ≈0,51pp): Contrato 73%, Abril-27 ~0%, Sigmoidal 73% (converge con Contrato porque ambas curvas ahora terminan el mismo mes). Subió levemente desde la versión anterior (70%/0%/70% a jul-26) por el buen ritmo de avance sostenido en agosto.
- Con solo 8 informes reales, tratar estas probabilidades como **indicativas**, no como proyección actuarial precisa.

---

## 4. Valor UF — construcción de la serie mensual

La serie de UF combina tres fuentes, de más a menos confiable:

1. **Datos reales** (siempre que existan): valor UF del día de cada giro bancario / pagaré, tomado directamente del mayor contable o la tabla de pagarés.
2. **Interpolación lineal** para meses intermedios sin dato directo.
3. **Tabla proyectada** que entregue el usuario para meses futuros (la última entregada: ago-26 a nov-27, variación +0,39%/mes). Para meses posteriores al final de esa tabla, **extrapolar a la misma tasa mensual** (+0,39%/mes salvo indicación en contrario).

**Regla de conversión:** cada avance mensual incremental se convierte a pesos usando el valor UF **del mes en que se paga/gira** (no el mes de devengo). Los montos acumulados en pesos son la **suma nominal** de esos montos mensuales — no se re-valorizan retroactivamente con el UF de hoy.

---

## 5. Avance Financiero Total (incluye crédito por Obras Previas)

Concepto clave introducido para reconciliar el avance físico (solo edificación) con la capacidad real que autoriza el banco (calculada sobre el contrato total, incluida la excavación ya ejecutada):

```
Avance Financiero Total Bruto(t) = Obras Previas Bruto (11.745,26 UF, fijo, 100%)
                                   + EEPP Scope Bruto (186.290,82 UF) × %Avance EEPP acumulado(t)

Avance Financiero Total % (t) = Avance Financiero Total Bruto(t) / Total Contrato Bruto (198.036,08 UF)
```

Esto da un % de avance **mayor** que el avance EEPP puro (ej. 34,27% vs 30,13% a jun-26), porque reconoce que parte del contrato (la excavación) ya está pagada y ejecutada aunque no se mida en el EEPP corto.

**Uso:** la capacidad bancaria autorizada acumulada = 90% × Avance Financiero Total Bruto(t). Comparada contra lo efectivamente girado, esto revela **capacidad no utilizada** que permite pedir al banco más del 90% del avance EEPP puntual en los meses donde aún no se ha "cobrado" el crédito de obras previas (ver ejemplo real: jun-26 y jul-26, donde se pudo pedir 100% en vez de 90%).

---

## 5b. Pedidas de Flujo al Banco — fórmula reconstruida (06-ago-2026)

Esta es la tabla `pedidas_banco` del reporte (pestaña Avances Financieros Banco, tarjeta "Pedidas de Flujo al Banco"), calculada por curva (Contrato / Abril-27 / Sigmoidal). Es un modelo **distinto** del Cuadro Maestro (§8): mientras el Cuadro Maestro usa el EEPP bruto puro, esta tabla usa el **Avance Financiero Total** (§5, incluye el crédito de Obras Previas), lo que le permite modelar capacidad bancaria no utilizada. Su fórmula no estaba documentada; se reconstruyó por ingeniería inversa contra los valores ya publicados (match exacto salvo centavos de redondeo) y quedó así, para cada índice mensual *i* (alineado al arreglo `labels`, oct-25 a abr-28):

```
Para jun-26 (i=8, ancla real, desfase histórico de 2 meses — financia el devengo de abr-26):
  pedida_bruto_uf[i]      = AFT_real_bruto[abr-26] − AFT_real_bruto[mar-26]
  banco_autorizado_acum[i]= 90% × AFT_real_bruto[jun-26]
  prestamo_uf[i]           = min(pedida_bruto_uf[i], banco_autorizado_acum[i] − total_girado_antes_junio_uf)
  banco_girado_acum[i]     = total_girado_antes_junio_uf + prestamo_uf[i]

Para jul-26 (i=9, ancla real, catch-up de 2 devengos — financia may-26 + jun-26 juntos):
  pedida_bruto_uf[i]      = (AFT_real_bruto[may-26]−AFT_real_bruto[abr-26]) + (AFT_real_bruto[jun-26]−AFT_real_bruto[may-26])
  banco_autorizado_acum[i]= banco_autorizado_acum[jun-26]  (se mantiene plano — no hay dato real de avance físico posterior a jun-26)
  prestamo_uf[i]           = GIRO REAL CONFIRMADO (pagaré/giro bancario efectivo, no la fórmula de capacidad máxima — ver nota abajo)
  banco_girado_acum[i]     = banco_girado_acum[jun-26] + prestamo_uf[i]

Desde ago-26 en adelante (i≥10, por curva seleccionada, desfase estándar de 1 mes):
  pedida_bruto_uf[i]       = AFT_<curva>_bruto[i−1] − AFT_<curva>_bruto[i−2]
  banco_autorizado_acum[i] = min(90% × AFT_<curva>_bruto[i−1], 178.232 UF)
  prestamo_uf[i]           = min(pedida_bruto_uf[i], banco_autorizado_acum[i] − banco_girado_acum[i−1])
  banco_girado_acum[i]     = banco_girado_acum[i−1] + prestamo_uf[i]

En todos los meses: aporte_propio_uf[i] = pedida_bruto_uf[i] − prestamo_uf[i]
                     prestamo_clp[i]     = prestamo_uf[i] × valor UF del mes i
```

**Nota clave sobre jul-26:** a diferencia de los meses proyectados, jul-26 es un mes real — su `prestamo_uf` no se calcula con la fórmula de capacidad máxima (eso daría un valor teórico, "lo máximo que se podría haber pedido"), sino que se fija al **giro real confirmado** por el pagaré (9.717,7 UF, §7). Como ese giro real quedó **por debajo** de la capacidad máxima autorizada ese mes (13.225,41 UF), queda un remanente de capacidad no utilizada (~3.507,71 UF) que el modelo recupera automáticamente en los meses siguientes (ago-26 en adelante), siempre que la curva de avance lo permita.

**Resultado del recálculo (21-sep-2026, tras EEPP N°7 y el reajuste sigmoidal), reemplaza los valores anteriores:**

| Curva | Préstamo total proyectado | Aporte propio total | Línea se agota en |
|---|---|---|---|
| Contrato | 178.232 UF (sin cambio) | 16.520,12 UF (sin cambio) | nov-27 |
| Abril-27 | 166.391,9 UF (sin cambio) | 14.202,11 UF (sin cambio) | No se agota |
| Sigmoidal | 178.232 UF (sin cambio en el total) | 19.774,76 UF (antes 19.791,39 UF) | nov-27 (sin cambio) |

**Cambio de esta actualización:** el nuevo EEPP N°7 (31-ago-2026, 43,63%) reajustó la curva sigmoidal completa (§3), lo que cambió el arreglo `AFT_sigmoid_bruto` desde ago-26 en adelante. Esto recalculó en cascada la columna Sigmoidal de `pedidas_banco` desde sept-26 (ago-26 se mantuvo con su `prestamo_uf` real fijo, 9.519,4 UF, pero su `pedida_bruto_uf` y `banco_autorizado_acum` — ambos dependientes de la curva — sí cambiaron levemente). Las columnas Contrato y Abril-27 **no se ven afectadas** por este reajuste porque no dependen de la curva sigmoidal.

La curva Abril-27 sigue siendo la más sensible a cada giro real que llega, porque su horizonte de construcción termina antes (abr-27) y no le da tiempo al modelo de recuperar remanentes de capacidad no utilizada antes de que la obra esté 100% terminada. Las columnas Contrato y Abril-27 **no dependen del ajuste sigmoidal** (usan su propia curva fija de avance), pero sí dependen igual que Sigmoidal de los giros reales confirmados mes a mes (jun-26, jul-26, ago-26).

**Al llegar un giro/pagaré real nuevo para un mes ya cubierto por este modelo:** reemplazar `prestamo_uf[i]` de ese mes por el giro real (no la fórmula de capacidad máxima) y re-ejecutar el recálculo en cascada para todos los meses posteriores, igual que se hizo aquí para ago-26 (y antes para jul-26).

**Decisión de alcance (17-ago-2026):** con ago-26 ahora confirmado real en el Cuadro Maestro (§8) y en este modelo, el ancla real de `banco_autorizado_acum` sigue plana desde jun-26 (no se extendió a jul-26 ni ago-26 en el cálculo de capacidad autorizada, solo se fijó `prestamo_uf` real para esos meses). Extender también `banco_autorizado_acum` afectaría por igual a las tres curvas y no fue parte del pedido explícito de esta pasada ("actualizar con el pagaré/giro nuevo"). Sigue como pregunta abierta en §11.

---

## 6. Financiamiento bancario (BCI)

- **Línea aprobada**: 178.232 UF = 90% × Total Contrato Bruto (198.036,08 UF). Este es el techo absoluto de todo lo que se puede girar de la línea (capital), sea por anticipo o por avance de obra.
- **Anticipo máximo autorizado**: 17.823 UF = 10% de la línea aprobada. El anticipo real girado fue 18.396,2 UF (pagaré de 18.500 UF, 16-abr-2026) — levemente sobre el máximo teórico, diferencia menor no investigada a fondo.
- **Tope de financiamiento por EEPP**: 90% del avance bruto del mes. El 10% restante (o más, si se agota la línea) se cubre con aporte propio / flujo de preventa.
- **El tope del 90% no aplica sobre el anticipo** — es un mecanismo separado.
- Cuando la línea aprobada (178.232 UF) se acerca a su límite acumulado, el modelo debe **capear** el préstamo mensual y trasladar el excedente a aporte propio (no reducir el gasto real de construcción, que sigue su curso).

### Desfase de pago (devengo → pedida)

Regla operativa real observada:
- Históricamente, **2 meses de desfase**: el EEPP de un mes X se paga a la constructora 2 meses después.
- **Julio-2026 fue el mes de recuperación**: se pagaron EEPP N°4 (avance mayo) y EEPP N°5 (avance junio) juntos, dejando el desfase en 1 mes desde ago-26 en adelante.
- Desde **agosto-2026**, desfase estabilizado en **1 mes**: el avance devengado en el mes M se paga/pide en el mes M+1.
- Al proyectar meses futuros, usar la curva de avance seleccionada (por defecto: Sigmoidal) para el devengo, aplicando este desfase de 1 mes.

---

## 7. Línea de crédito — datos reales (pagarés)

La fuente de verdad es la **tabla de pagarés** (no el mayor contable "Préstamos Bancarios", que ha quedado desactualizado más de una vez). Cada pagaré trae: N° pagaré, monto UF, fecha de otorgamiento, fecha de vencimiento, tasa, capital adeudado/pagado, interés devengado a la fecha e interés estimado al vencimiento.

**Estado a la última actualización** (9 pagarés, sin cambio en el número desde la pasada anterior — solo se refrescó el interés devengado y se formalizó el código del 9° pagaré; fuente: "Calendario vctos creditos y bol.xlsx", pestaña "Calendario anual.PG Y CREDITO", filas OBRA = "Rocas del Aguila". Nota: el archivo puede llegar guardado en "Resumen Proyectos" o en "Rocas" — revisar ambas carpetas si un "actualizar" no muestra cambios en la primera):

| Pagaré | Monto (UF) | Otorgamiento | Vencimiento | Tasa |
|---|---|---|---|---|
| D09077563934 | 3.000 | 29-12-2025 | 21-12-2026 | 4,40% |
| DO9077568882 | 9.000 | 05-02-2026 | 20-01-2027 | 4,17% |
| DO90224158 | 5.823 | 12-03-2026 | 09-12-2026 | 3,50% |
| DO9077578043 | 18.500 | 16-04-2026 | 03-12-2026 | 2,75% |
| D09077580774 | 5.000 | 12-05-2026 | 07-05-2027 | 3,08% |
| D09077583338 | 4.000 | 05-06-2026 | 01-04-2027 | 3,94% |
| D09077585714 | 6.500 | 24-06-2026 | 17-06-2027 | 4,59% |
| DO9077588449 | 9.800 | 22-07-2026 | 15-07-2027 | 4,13% |
| DO9077590998 | 9.600 | 14-08-2026 | 12-03-2027 | 4,14% |
| **Total** | **71.223** | | | |

- Interés devengado a la fecha (última actualización, 21-sep-2026): 893 UF total (antes 664 UF — sube porque el archivo fuente calcula devengo con TODAY(), y pasó ~1 mes).
- Interés estimado al vencimiento: 2.191 UF total (costo financiero de la línea, estable).
- Capital pagado: 0 UF (sin amortización de capital aún).
- Saldo disponible de la línea: 178.232 − 71.223 = **107.009 UF** (cruzado contra la pestaña "Giros L.Crédito", fila Rocas del Aguila: 71.222,71 UF girados — coincide).
- El 9° pagaré (9.600 UF, otorgado 14-08-2026) ya tiene código formal: **DO9077590998** (antes figuraba pendiente/sin código).
- El interés devengado depende de TODAY() en el archivo fuente (crece mes a mes); el interés al vencimiento es estable. Al leer el archivo, refrescar ambos campos para todos los pagarés, no solo el nuevo.

**Al llegar pagarés nuevos:** agregar filas, sumar al total girado, y verificar si cambia el "saldo disponible de la línea" (178.232 − total girado). El monto del pagaré (columna "Inicial UF"/"Adeudado UF" de la tabla `Tabla2`) es el capital nominal girado; el giro neto efectivo suele ser ~0,5–1,5% menor por descuentos de la operación (ver nota de conversión pagaré→giro real más abajo).

**Conversión pagaré (nominal) → giro real (neto) en el Cuadro Maestro:** las cifras de "Pedido Banco" mensual reales en el Cuadro Maestro (§8) no son el monto nominal del pagaré, sino el giro neto efectivamente cursado, que ha sido consistentemente ~0,8-1,5% menor (ratios observados: dic-25 99,2%; feb-26 99,2%; mar-26 99,4%; abr-26 99,4%; may-26 98,5%; jun-26 99,2%). Cuando llega un pagaré nuevo sin dato bancario confirmado del giro neto, aplicar el promedio histórico (~99,16%) como estimador provisional y reemplazar por el dato real en cuanto esté disponible.

### 7b. Gastos Financieros — Interés Real vs. Proyectado, modelo de renovación (29-sep-2026, v2)

Tarjeta en el reporte (`DATA.gastos_financieros`), pedida por el usuario para separar el interés ya comprometido (pagarés reales, emitidos) del interés aún estimado (pedidas de plata futuras, todavía sin pagaré). Definición del usuario: "real" = asociado a pagarés ya emitidos (aunque no pagados aún, porque tienen fecha de vencimiento cierta); "proyectado" = asociado a futuras pedidas de plata que aún no se giran.

**v1 (primera pasada, superada):** se calibró la porción proyectada usando directamente la forma mensual de la fila "Costos Financieros" del flujo de caja (ago-27 a abr-28), reescalada para cerrar exacto en 15.770 UF. El usuario corrigió el enfoque: faltaba el concepto de **renovación** — el crédito no se paga al año, se renueva indefinidamente a la misma tasa hasta que llega el pago real de la deuda.

**v2 (modelo de renovación, vigente):** cada pagaré (real o proyectado) es un tramo de capital que **se renueva a la misma tasa**, generando un cargo de interés nuevo en cada aniversario, hasta el mes en que ese tramo de capital efectivamente se paga. El pago de capital no ocurre al vencimiento nominal de cada pagaré, sino cuando llega dinero grande al flujo de caja (venta de escrituras).

**Corrección v2.1 (29-sep-2026):** el usuario aclaró que los 9 pagarés reales tienen una **duración contractual definida y no debe modificarse** — no todos son de 12 meses parejo (varían entre ~210 y ~360 días, ver fechas de otorgamiento/vencimiento en §7). Se corrigió el modelo: para cada pagaré real, el **primer** cargo de interés usa su plazo contractual exacto (otorgamiento → vencimiento real, con interés prorrateado días/365 sobre esa duración específica), y **solo a partir de ahí** se renueva cada 12 meses (ya no hay una fecha contractual siguiente, así que se asume renovación anual estándar). Únicamente las pedidas futuras sin pagaré (13 proyectadas + el giro de sept-26, sin documento formal todavía) usan 1 año desde el giro para su primer período, como pidió el usuario.

**Cronograma de pago de capital** — fuente: `IG_Rocas del Águila.xlsx`, hoja "3.FlujodeCaja_Consolidado", fila 59 "Amortizaciones Prestamos Bancos". El saldo de deuda (fila 60) se mantiene plano en 178.231,99 UF desde nov-2027 hasta ene-2028, y se paga en 3 cuotas cortas: **feb-2028 (−50.000 UF), mar-2028 (−80.000 UF), abr-2028 (−48.232 UF)** — total 178.232 UF, exacto contra la línea aprobada. Esto confirma la observación del usuario: "el período de pago es corto, 3 meses, e inicia justo cuando llegan los primeros pagos de escrituras".

**Asignación de capital a cuotas (FIFO):** se ordenan todos los tramos de capital cronológicamente por fecha de originación (9 pagarés reales + el giro real de sept-26, aún sin pagaré formal + las 13 pedidas proyectadas oct-26 a oct-27) y se consumen en ese orden contra las 3 cuotas de pago — el primero en pedirse es el primero en pagarse. Si el límite de una cuota cae a mitad de un tramo, ese tramo se divide en dos "piezas" con la misma tasa pero distinta fecha de pago (ocurre con el pagaré D09077585714 en la cuota feb/mar-2028, y con la pedida proyectada de ene-27 en la cuota mar/abr-2028).

**Tasas usadas:**
- Los 9 pagarés reales: su propia tasa contractual (tabla de §7, 2,75%-4,59%).
- Giro real de sept-26 (13.831,61 UF, aún sin pagaré formal): 4,14% (misma tasa del último pagaré real, DO9077590998, ago-26) — actualizar en cuanto llegue el pagaré formal.
- Las 13 pedidas proyectadas (oct-26 a oct-27, montos = `cuadro_maestro.banco` proyectado, fuente flujo de caja fila "Prestamos Bancarios"): 3,98% (promedio de las tasas de los últimos 5 pagarés reales, may-26 a ago-26) — "condiciones similares a lo ya recibido", según pidió el usuario.

**Cálculo del interés por tramo:** desde la fecha de originación, se genera un cargo (capital × tasa) en cada aniversario de 12 meses mientras el tramo siga vigente, más un cargo de cierre proporcional (capital × tasa × días/365) desde el último aniversario hasta la fecha de pago real de ese tramo.

**Resultado:**
- Interés Real (10 tramos: 9 pagarés a su plazo contractual real + sept-26 pendiente a 1 año): **5.693,1 UF**, entre dic-26 y mar-28.
- Interés Proyectado (13 tramos, todos a 1 año): **4.379,0 UF**, entre oct-27 y abr-28.
- **Total: 10.072,1 UF.**

(Nota: las 3 fechas de pago de capital se normalizaron a **fin de mes** — 29-feb-2028/31-mar-2028/30-abr-2028, en vez de los días 28/31/30 usados en una pasada intermedia — para que el modelo base coincida exactamente con el motor genérico de la pestaña de sensibilidad, §7c. El efecto es de ~5 UF sobre el total, irrelevante.)

**Picos con más de una renovación/cierre el mismo mes** (campo `n_items` en `DATA.gastos_financieros`, se anota "×N" sobre la barra en el gráfico): con los plazos reales, **dic-26 ya trae ×3** (tres pagarés cortos vencen ahí: DO90224158, DO9077578043 y D09077563934), luego jun-27 (×2), dic-27 (×4), ene-28 (×3), y los tres meses de pago de capital concentran la mayoría de los cierres — **feb-2028 (×8), mar-2028 (×10), abr-2028 (×10)** — porque ahí vencen simultáneamente las últimas renovaciones y los cierres proporcionales de casi todos los tramos, tal como anticipó el usuario ("diciembre 2027 o enero 2028" — el efecto real resultó ser más fuerte y algo más tardío, en feb-abr 2028, alineado con el propio cronograma de amortización del flujo de caja).

**Brecha vs. el flujo de caja (10.072,1 UF vs. 15.770,18 UF de la fila "Costos Financieros"):** el modelo de renovación a tasa constante da ~5.700 UF menos que el total que reporta el flujo de caja. Posibles explicaciones no incorporadas en este modelo: una tasa de renovación más alta que la original (spread creciente), comisiones u otros costos financieros bancarios además del interés puro, o un supuesto de capitalización de intereses (interés sobre interés) en el propio flujo de caja, o una fecha de recuperación de deuda más tardía que la que hoy muestra el flujo de caja. Ver §7c para un modelo que explora justamente esta última hipótesis.

**Al llegar un pagaré nuevo real (incluido el de sept-26 cuando se formalice), o al confirmarse una tasa de renovación real:** actualizar el tramo correspondiente (tasa, fecha) y volver a correr el modelo completo (todos los tramos se re-ordenan y re-asignan a las cuotas FIFO, porque un cambio de capital/fecha temprano puede correr todos los cortes posteriores). El mismo cambio debe replicarse en `DATA.gastos_financieros_model.tranches` (pestaña de sensibilidad, §7c), que usa la misma lista de tramos pero recalcula todo en el navegador.

### 7c. Pestaña "Análisis de Sensibilidad" — fecha de recuperación variable (29-sep-2026)

Nueva pestaña del reporte, pedida por el usuario para ver cómo cambian (y crecen) los gastos financieros según cuándo empieza realmente a pagarse la deuda — hoy el modelo de §7b fija esa fecha en el 29-feb-2028 (primera de 3 cuotas de amortización según el flujo de caja), pero es un supuesto, no un hecho confirmado.

**Motor del modelo, portado a JavaScript** (`DATA.gastos_financieros_model` + funciones `sens*` al final del `<script>`): la misma lógica de tramos/renovación/asignación FIFO de §7b, pero parametrizada por una **fecha de inicio de recuperación** que se puede mover. Los tramos (23: 9 pagarés reales + sept-26 pendiente + 13 proyectados, con su capital, tasa, fecha de origen y fecha de primer vencimiento) se embeben como datos crudos en `DATA.gastos_financieros_model.tranches`; todo el cálculo (asignación de capital a las 3 cuotas de pago, cargos de interés por renovación/cierre, agregación mensual) se recalcula en el navegador cada vez que cambia la fecha. Las 3 cuotas de pago (50.000 / 80.000 UF / resto) siempre se ubican a **fin de mes**, empezando por el mes de la fecha elegida.

**3 secciones de la pestaña:**
1. **Modelo Base** — recuperación fija en 29-feb-2028 (igual a §7b, mismo total: 10.072,1 UF). Sirve de referencia/control de consistencia contra la pestaña "Avances Financieros Banco".
2. **Modelo Calibrado** — se busca por bisección (50 iteraciones sobre un rango de hasta ~5 años) la fecha de recuperación que hace que el total de gastos financieros iguale la meta de **15.770 UF** del flujo de caja. Resultado: **~01-dic-2028** (~9-10 meses después que el modelo base), con un total de **~15.854 UF** (el modelo es una función escalón por los cargos discretos mensuales, así que la bisección converge al primer día donde el total supera la meta, no exactamente a ella — la diferencia, ~84 UF, es el "salto" del cargo más próximo). Esto sugiere que, si el presupuesto de 15.770 UF del flujo de caja es correcto, la recuperación real de la deuda podría estar ocurriendo varios meses después de lo que hoy muestra la fila "Amortizaciones Prestamos Bancos" — o bien la tasa de renovación asumida (3,98%-4,59%) es más baja que la real.
3. **Interactivo** — un `<input type="date">` deja elegir cualquier fecha de recuperación y un `<input type="number">` deja elegir la tasa de los 13 pagarés proyectados (default 3,98%, un decimal — los 9 pagarés reales y el giro de sept-26 siempre mantienen su propia tasa contractual, no se ven afectados por este control). El gráfico de flujo mensual (igual formato que §7b, con anotación "×N" en los meses de renovación múltiple) y las KPIs (Real/Proyectado/Total, con delta vs. el modelo base) se recalculan al vuelo con ambos parámetros. Debajo, un gráfico de sensibilidad muestrea el total cada 2 meses desde el modelo base hasta +3 años **a la tasa actualmente seleccionada**, con una línea punteada en la meta de 15.770 UF y un punto rojo marcando la fecha elegida — para visualizar de un vistazo cómo crecen los gastos financieros cuanto más tarde se recupera la deuda y/o más alta es la tasa de renovación de las pedidas futuras.

**Mantenimiento:** cualquier cambio a los tramos de §7b (nuevo pagaré real, tasa de renovación confirmada, nueva fuente de las pedidas proyectadas) debe reflejarse también en `DATA.gastos_financieros_model.tranches` para que ambas pestañas no diverjan.

### 7d. Tabla "Pagarés Proyectados" (29-sep-2026)

Tabla nueva en la pestaña "Avances Financieros Banco", justo después de la tabla de pagarés reales, pedida por el usuario con el mismo formato (Pagaré, Monto, F. Otorgamiento, F. Vencimiento, Tasa, Interés) pero para los 13 giros futuros al banco (`DATA.linea_bancaria.pagares_proyectados`, derivada de los mismos 13 tramos `real:false` de `DATA.gastos_financieros_model.tranches`, §7c — no es una fuente nueva, solo se expone en formato tabla). F. Otorgamiento estimada = día 15 del mes de cada giro proyectado (placeholder, no hay fecha exacta hasta que se emita el pagaré real); F. Vencimiento = otorgamiento + 1 año; Tasa = 3,98% (promedio de los últimos 5 pagarés reales) para las 13 filas; Interés Proyectado = solo el cargo del primer período (capital × tasa), sin incluir renovaciones posteriores (esas están en la tarjeta "Gastos Financieros" y la pestaña de sensibilidad). Total: 93.732,3 UF de capital, 3.730,7 UF de interés del primer período. **Al emitirse cada pagaré real:** mover esa fila de esta tabla a la tabla de pagarés reales con sus datos exactos (código, fecha, tasa), igual que se hizo con ago-26 (§7, "Actualización 9° pagaré").

---

## 8. Cuadro Maestro — Pedidos al Banco y Avances Brutos a la Constructora

Tabla mensual jul-2025 → oct-2027 con dos series: **EEPP bruto pagado a la constructora** y **pedido al banco**, cada una con su acumulado.

### Meses reales (fijos, no se recalculan con las curvas)

| Mes | EEPP Bruto (UF) | Pedido Banco (UF) |
|---|---|---|
| jul-25 | 2.501 | – |
| ago-25 | 5.159 | – |
| sept-25 | 1.445 | – |
| oct-25 | – | – |
| nov-25 | 2.143 | – |
| dic-25 | – | 2.976 |
| ene-26 | 9.010 | – |
| feb-26 | 5.501 | 8.929 |
| mar-26 | 4.172 | 5.788 |
| abr-26 | 20.538 | 18.396 |
| may-26 | 3.983 | 4.925 |
| jun-26 | 5.579 (EEPP N°3) | 10.417 |
| jul-26 | 17.706 (EEPP N°4 = 7.888 + EEPP N°5 = 9.818) | 9.717,7 (confirmado por pagaré real DO9077588449, 9.800 UF nominal, otorgado 22-jul-2026, neto ~99,16% aplicando el descuento histórico promedio) |
| ago-26 | **9.596 (pagado a la constructora en agosto-2026, confirmado por el usuario)** | **9.519,4 (confirmado por pagaré nuevo sin código aún, 9.600 UF nominal, otorgado 14-ago-2026, neto ~99,16%)** |

Totales reales a jun-26: **60.031 UF** EEPP bruto / **51.431 UF** banco.
Con jul-26 incluido: **77.737 UF** EEPP bruto / **61.148,7 UF** banco.
Con ago-26 incluido: **87.333 UF** EEPP bruto / **70.668,1 UF** banco acumulado a ago-26.
Con sept-26 incluido: **99.164,6 UF** EEPP bruto / **84.499,7 UF** banco acumulado a sept-26. `n_real_months` = 15, `corte_real` = "sept-26" (ambas series ya son reales hasta sept-26).

### Meses proyectados (sept-26 en adelante)

- Se distribuye el **saldo remanente** hasta los targets de término, proporcional a la forma de la **curva sigmoidal, desfasada 1 mes** (peso del mes M = incremento mensual sigmoidal del mes M-1 — refleja que el pedido/pago de un mes financia el devengo del mes anterior). Esta es la fórmula exacta verificada contra los valores ya publicados del reporte.
- **Targets de cierre en oct-27**: 198.139 UF de EEPP bruto pagado a la constructora, 178.232 UF pedido al banco (= 100% de la línea aprobada).
- El aporte propio de cada mes = EEPP Bruto − Pedido Banco.
- **Actualización ago-2026:** al confirmarse el giro real de jul-26 (9.717,7 UF, antes estimado en ~16.256 UF), el remanente a distribuir entre ago-26 y oct-27 se recalculó (117.083,3 UF), manteniendo el mismo target de cierre (178.232 UF) y el mismo esquema de pesos.
- **Actualización EEPP N°6 (06-ago-2026):** al reajustarse la curva sigmoidal con el nuevo punto real (jul-26, 36,17%), los pesos de distribución de ago-26 a oct-27 cambiaron (la forma de la curva se corrió), así que tanto el EEPP Bruto como el Pedido Banco proyectados de esos meses se recalcularon manteniendo los mismos meses reales (fijos hasta jul-26) y los mismos targets de cierre (198.139 / 178.232 UF).
- **Actualización 9° pagaré (17-ago-2026, primera pasada):** el "Pedido Banco" de ago-26 pasó de proyectado a real (9.519,4 UF), confirmado por el nuevo pagaré del 14-ago-2026. El "EEPP Bruto" de ago-26 quedó proyectado en esa pasada (mes mixto).
- **Actualización EEPP bruto ago-26 (17-ago-2026, segunda pasada):** el usuario confirmó el pago real de agosto-2026 a la constructora (9.596 UF, ya pagado hoy). Se promovió `eepp_bruto[ago-26]` de proyectado (11.707,7 UF) a real (9.596 UF) — con esto, ago-26 queda completamente real en ambas series (`n_real_months`=14, `corte_real`="ago-26"). Se redistribuyó el remanente de sept-26 a oct-27 (14 meses) reescalando proporcionalmente los pesos existentes de esos mismos meses para que sumen el nuevo saldo remanente (110.806 UF, antes 108.694,3 UF proyectados), forzando el cierre exacto en oct-27 (198.139 UF). El Pedido Banco de esos meses no cambió (su propia serie/target es independiente).
- **Actualización EEPP N°7 (21-sep-2026):** con el reajuste completo de la curva sigmoidal (§3, nuevo punto ago-26=43,63%), se recalcularon los pesos de distribución sept-26 a oct-27 desde cero (no por reescalado proporcional esta vez, sino recomputando `parciales.sigmoid[cm_i-4]` para cada mes proyectado). Los 14 meses reales (jul-25 a ago-26) no cambiaron. Los targets de cierre se mantuvieron (198.139 / 178.232 UF) y ambas series cierran exacto en oct-27.
- **Actualización sept-26 (25-sep-2026):** el usuario confirmó que la fila "Prestamos Bancarios" y "Edificación" del flujo de caja consolidado del proyecto (`IG_Rocas del Águila.xlsx`, pestaña "3.FlujodeCaja_Consolidado", columna sept-26) son reales, aunque el propio archivo etiqueta esa columna como "Proyección" (su corte "Real a la Fecha" interno es 31-ago-2026). Se promovió sept-26 a real: `eepp_bruto[sept-26]` = 12.940 UF (provisorio, ver corrección abajo), `banco[sept-26]` = 14.940 UF. Con esto `n_real_months` = 15, `corte_real` = "sept-26". Se redistribuyó el remanente de oct-26 a oct-27 (13 meses) con los mismos pesos sigmoidales, manteniendo los targets de cierre (198.139 / 178.232 UF). **Nota de fuente:** a diferencia de los meses reales anteriores (anclados en pagarés o confirmación directa del usuario), este mes usa una fila de un archivo de flujo de caja cuya propia cabecera lo marca como proyección — si llega un pagaré o EEPP formal para sept-26 que dé una cifra distinta, reemplazar por ese dato.

**Confirmación del desfase de pago para el EEPP Bruto (28-sep-2026):** el usuario confirmó explícitamente la regla de desfase que ya estaba codificada en el peso sigmoidal (`peso[mes M] = parcial sigmoid[mes M−1]`, ver arriba): el EEPP Bruto pagado en un mes corresponde al **devengo físico del mes anterior**. `eepp_bruto[sept-26]` (real) corresponde al devengo de **ago-26** (EEPP N°7, 43,63%); `eepp_bruto[oct-26]` (proyectado) usa como peso el incremento sigmoidal proyectado de **sept-26** — no hay EEPP N°8 real todavía, así que ese mes sigue con el valor estimado por la curva. **Regla explícita para la próxima actualización:** cuando llegue el EEPP N°8 (avance físico real de sept-26), su pago correspondiente se reflejará en el flujo de caja de **octubre-2026**, no en septiembre — mover `eepp_bruto[oct-26]` (no `sept-26`) de proyectado a real en ese momento.

**Corrección eepp_bruto[sept-26] (28-sep-2026):** el usuario indicó que la fuente correcta para el monto de sept-26 no es la fila "Edificación" del flujo de caja (12.940 UF, estimado), sino el propio archivo EEPP N°7 (`EEPP N°7 Obra Casas Rocas del Aguila Inmobiliario.xlsx`, hoja "Avance n° 7", fila "Total Proyecto", columna "Actual" [N376]) = **11.831,6059283055 UF**. Este es el monto de avance monetario devengado en el período de EEPP N°7 (bruto con IVA, incluyendo utilidad, antes de anticipo/retención), que se paga con 1 mes de desfase en sept-26. Se reemplazó `eepp_bruto[sept-26]` = 11.831,61 UF (antes 12.940 UF) y se redistribuyó nuevamente oct-26 a oct-27 con el nuevo saldo remanente (98.974,4 UF, antes 98.199 UF), manteniendo el target de cierre (198.139 UF). Nuevo acumulado a sept-26: **99.164,6 UF** (antes 100.273 UF). El Pedido Banco (14.940 UF, fuente flujo de caja) no cambió en esta pasada — ver corrección siguiente.

**Corrección banco[sept-26] (28-sep-2026):** el usuario actualizó el archivo `IG_Rocas del Águila.xlsx` (mtime 28-sep-2026 12:19, reemplazando la versión leída el 25-sep). En la nueva versión, fila "Edificación" de sept-26 ya coincide exactamente con la corrección de EEPP N°7 recién aplicada (-11.831,61 UF) — señal de que el usuario sincronizó el flujo de caja con este reporte —, y las proyecciones de "Edificación" oct-26 a oct-27 coinciden (con una diferencia de ~10 UF en oct-27, redondeo) con nuestra propia serie `eepp_bruto` proyectada, confirmando que el archivo adoptó nuestra redistribución como insumo. El único dato realmente nuevo es la fila "Prestamos Bancarios" de sept-26, que cambió de 14.940 UF a **13.831,61 UF**. El usuario confirmó que es un dato real ("si, actualiza porque son datos reales"). Se reemplazó `banco[sept-26]` = 13.831,61 UF (antes 14.940 UF) y se redistribuyó el remanente de oct-26 a oct-27 (13 meses) reescalando proporcionalmente los pesos existentes de esos mismos meses (mismo método usado en la pasada del 17-ago-2026) para que sumen el nuevo saldo remanente (93.732,3 UF, antes 92.623,9 UF), manteniendo el target de cierre (178.232 UF). Nuevo acumulado a sept-26: **84.499,7 UF** (antes 85.608,1 UF). El aporte propio de sept-26 quedó en -2.000 UF (EEPP bruto 11.831,61 − banco 13.831,61), es decir el banco giró 2.000 UF más de lo devengado ese mes — probablemente un adelanto o ajuste de outstanding, no un descuadre.

**Al llegar un mes nuevo real** (nuevo EEPP pagado y/o nuevo pedido bancario confirmado):
1. Mover ese mes de "proyectado" a "real" con el valor exacto (el EEPP bruto y el Pedido Banco de un mes pueden confirmarse en momentos distintos — como pasó con ago-26, banco confirmado antes que el EEPP bruto — tratarlos como campos independientes, no forzar que ambos pasen a real juntos).
2. Recalcular el remanente a distribuir entre los meses proyectados que quedan, manteniendo los targets de cierre (198.139 / 178.232 UF) salvo que el usuario entregue targets nuevos. Cada serie (EEPP Bruto, Pedido Banco) se redistribuye de forma independiente sobre su propio remanente, aunque comparten la misma forma de pesos (sigmoidal desfasada 1 mes).

---

## 9. Estructura del reporte HTML

Archivo: `Rocas_del_Aguila_Avance_Obra.html` — autocontenido (Chart.js embebido inline, sin depender de CDN externo, porque el visor de artefactos puede bloquear conexiones a internet).

**3 pestañas:**
1. **Avance de Obra**: KPIs, gráfico de curvas (con selector Acumulado/Parcial y multi-selección de curvas), tarjetas de probabilidad Monte Carlo, tabla de datos reales.
2. **Avances Financieros Banco**: estructura del contrato, Avance Financiero Total, Línea de Crédito Bancaria (pagarés), Cuadro Maestro, Pedidas de Flujo al Banco, Avance Financiero Estimado (toggle CLP/UF).
3. **Supuestos y Fuentes**: metodología completa documentada, tabla de valor UF, fuentes de datos.

**Paleta Tasco:** navy `#0e2447`, gray `#8d929d`, white `#ffffff`, dark green `#2b424a`, slate `#465768`, terracotta `#ad4736`, sand `#aa806d`, cream `#d8cdc5`.

**Reglas técnicas del HTML:**
- Chart.js **embebido inline** en un `<script>` (no CDN) — evita el error "Chart is not defined" en el visor de artefactos.
- Todos los datos van en un objeto `DATA` embebido como JSON al final del `<head>`/inicio del `<body>`.
- Selectores de curva son botones (no `<select>`), clase `curve-btn` / `curve-btn2` / `curve-btn3` según la tarjeta (para no cruzar listeners entre secciones).
- Curva por defecto seleccionada en todos los selectores: **Sigmoidal**.

---

## 10. Checklist para actualizar el reporte con información nueva

1. **¿Hay un EEPP nuevo?** → agregar punto real a la curva, re-ajustar y renormalizar la sigmoidal, recalcular todo lo que depende de ella.
2. **¿Hay un pagaré nuevo o un giro bancario nuevo?** → agregar a la tabla de pagarés, actualizar total girado y saldo disponible de línea.
3. **¿Hay un mes nuevo confirmado en el Cuadro Maestro?** → moverlo de proyectado a real, redistribuir el remanente.
4. **¿Cambió algún supuesto** (tasa de IVA, % del tope bancario, meta de término, valores UF proyectados)? → actualizar la constante correspondiente y recalcular en cascada (todo el modelo está encadenado: contrato → curvas → avance financiero total → pedidas banco → cuadro maestro).
5. Verificar que los totales de cierre a término sigan calzando con los targets vigentes (198.139 UF EEPP bruto, 178.232 UF banco) — si el usuario da targets nuevos, reemplazar y re-escalar la distribución proporcional.
6. Regenerar el HTML completo (no editar el HTML final a mano — regenerar desde los datos para evitar inconsistencias entre pestañas).

---

## 11. Preguntas abiertas / cosas a confirmar con el usuario cuando corresponda

- ~~Cifra real del "pedido al banco" en jul-26~~ — **Resuelto (06-ago-2026):** confirmado en 9.717,7 UF vía el pagaré real DO9077588449 (9.800 UF nominal, otorgado 22-jul-2026), reemplazando la estimación proporcional (~16.256 UF). El monto neto exacto del giro (vs. el nominal del pagaré) sigue siendo una estimación basada en el descuento histórico promedio (~0,84%) — confirmar con el usuario si tiene el monto neto exacto del giro bancario de jul-26.
- Mecanismo exacto de amortización del anticipo bancario (hoy modelado como recuperación proporcional al avance acumulado — validar contra las bases del contrato de crédito).
- Pequeña brecha (~411 UF) entre el total EEPP "bottom-up" y el total contractual corregido — no crítica, pero pendiente de explicar si el usuario lo pide.
- Reparto mes a mes del Cuadro Maestro desde ago-26 en adelante: hoy es proporcional a la curva sigmoidal (desfasada 1 mes) por defecto de diseño propio, no una instrucción explícita del usuario — confirmar si prefiere otro criterio.
- ~~"Pedidas de Flujo al Banco" desactualizada~~ — **Resuelto (06-ago-2026):** se reconstruyó la fórmula completa (antes no documentada) y se sincronizó con el giro real de jul-26. Ver §5b más abajo para el detalle de la fórmula y el resultado del recálculo.
- **"Pedidas de Flujo al Banco" — ¿extender el ancla real a jul-26/ago-26?** Con el EEPP N°6 (36,17% a jul-26) ya existe avance físico real más allá de jun-26, lo que permitiría que `banco_autorizado_acum` use datos reales de jul-26 (físico) y ahora también de ago-26 (financiero, vía el 9° pagaré) en vez de mantenerse plano desde jun-26 (ver §5b). No se aplicó en esta actualización ni en la del 17-ago-2026 porque afectaría por igual a las 3 curvas (el ancla es compartida) y los pedidos han sido acotados ("actualizar con el EEPP nuevo", luego "actualizar con el pagaré nuevo") — confirmar con el usuario si prefiere que se extienda, y considerar hacerlo de una vez con el próximo dato real que llegue (evita seguir posponiéndolo).
- ~~Cifra real del "pedido al banco" en ago-26~~ — **Resuelto (17-ago-2026):** confirmado en 9.519,4 UF vía el 9° pagaré (9.600 UF nominal, otorgado 14-ago-2026, sin código formal aún en "Calendario PAGARE"). El EEPP Bruto de ago-26 sigue proyectado (sin EEPP N°7). Se agregó el pagaré a §7 (9 pagarés, total 71.223 UF), se promovió el Pedido Banco de ago-26 a real en el Cuadro Maestro (§8) y se recalculó Pedidas de Flujo al Banco (§5b) en las 3 curvas — Abril-27 bajó su préstamo total proyectado de 169.540,3 a 166.391,9 UF.
- **Archivo fuente llega a carpetas distintas.** Esta actualización (y la anterior) llegaron guardadas en "Resumen Proyectos" en vez de "Rocas", donde se buscaba por defecto — costó 2-3 intentos de "actualizar" detectar el cambio. Si un "actualizar" no muestra diferencias en la carpeta habitual, buscar el archivo por nombre en todas las carpetas montadas antes de concluir que no hay cambios.
- ~~Código formal del 9° pagaré~~ — **Resuelto (21-sep-2026):** el pagaré del 14-ago-2026 ya aparece con código **DO9077590998** en "Calendario anual.PG Y CREDITO". Actualizado en §7 y en el reporte.
- **"Capacidad No Utilizada" (tarjeta en Avance Financiero Total):** el usuario pidió explícitamente (21-sep-2026) cambiar manualmente esta cifra a 7.671 UF para el corte jul-26, sin dar la fórmula/fuente de ese número (distinto del valor calculado por el modelo, 13.634 UF). En esta misma actualización la tarjeta avanzó de corte jul-26 a ago-26 (por el nuevo EEPP N°7), y se recalculó con la fórmula estándar del modelo (83.722 UF capacidad autorizada − 67.098,91 UF girado real = 16.623 UF), **sin preservar el ajuste manual del usuario** porque no está claro si aplicaba solo al corte jul-26 o es una corrección estructural a la fórmula. Confirmar con el usuario si esta tarjeta debe seguir calculándose con la fórmula del modelo o si tiene una fuente/corrección distinta que prefiere aplicar de forma permanente.
- **EEPP N°8 pendiente:** el nuevo EEPP N°7 (corte 31-ago-2026) fue incorporado el 21-sep-2026. Cuando llegue el EEPP N°8 (o un giro/pagaré nuevo), seguir el mismo proceso: §3 (reajuste sigmoidal), §5b (recálculo pedidas_banco columna Sigmoidal), §8 (Cuadro Maestro, redistribución sept-26+ si corresponde), Monte Carlo (§3), y sweep de textos estáticos.
