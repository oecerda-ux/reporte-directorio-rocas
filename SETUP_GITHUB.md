# Publicar el reporte en GitHub — configuración de una sola vez

Repositorio: https://github.com/oecerda-ux/reporte-directorio-rocas

El repo local ya está creado en esta carpeta (primer commit hecho). Faltan unos pasos, todos en tu computador — ni las credenciales ni ciertas operaciones de git las puedo hacer yo desde acá (mi acceso a esta carpeta puede crear/escribir archivos pero no borrarlos, y git necesita borrar archivos de bloqueo temporales para funcionar bien).

## 0. Reparar 3 archivos de bloqueo sueltos (una vez)

Abre PowerShell o CMD en esta carpeta y corre:

```
cd "C:\Users\Osvaldo Cerda\Downloads\TASCO\Inmobiliaria\Reportería\Directorio Inmobiliario\Rocas"
del .git\index.lock
del .git\HEAD.lock
del .git\refs\heads\master.lock
git status
```

El último comando (`git status`) debería mostrar el repo normal, sin errores. Si borrar alguno de estos con `del` da error de "no encontrado", ignóralo — puede que ya no exista.

## 1. Revoca los tokens que se pegaron en el chat

Ve a github.com → foto de perfil → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**, y borra (Delete) cualquier token que hayas pegado en una conversación con Claude. Son credenciales expuestas y no deberían seguir activas.

## 2. Genera un token nuevo (solo para usar en tu terminal, nunca en el chat)

En la misma pantalla, **Generate new token (classic)**:
- Nombre: algo como `reporte-rocas-push`
- Expiración: la que prefieras (90 días, 1 año, sin expiración)
- Permisos: marca **repo** (acceso completo a repositorios)
- Copia el token que te muestra (empieza con `github_pat_` o `ghp_`) — no lo vas a volver a ver.

## 3. Autentícate una vez en tu terminal (PowerShell o CMD)

```
cd "C:\Users\Osvaldo Cerda\Downloads\TASCO\Inmobiliaria\Reportería\Directorio Inmobiliario\Rocas"
git config --global credential.helper manager
git push -u origin master
```

Te va a pedir usuario y contraseña:
- **Username**: tu usuario de GitHub (`oecerda-ux`)
- **Password**: pega el token nuevo (no tu contraseña de GitHub)

Con `credential.helper manager`, Windows guarda esa credencial cifrada en el Administrador de Credenciales — de ahí en adelante, ni tú ni el script tendrán que volver a escribirla.

## 4. Prueba el script de publicación automática

Ya dejé listo `auto_push.bat` en esta misma carpeta. Haz doble clic en él (o córrelo desde la terminal). Debería decir "Publicado correctamente" sin pedirte nada, porque ya quedó la credencial guardada en el paso 3.

## 5. (Opcional pero recomendado) Automatízalo con el Programador de Tareas de Windows

Así se sube solo cada vez que yo actualice el reporte, sin que tengas que hacer clic:

1. Abre **Programador de tareas** (busca "Task Scheduler" en el menú de inicio).
2. **Crear tarea básica** → nombre: `Push Reporte Rocas`.
3. Desencadenador: **Diariamente**, repetir cada **15 minutos** durante **1 día** (o el intervalo que prefieras) — en el asistente básico puedes elegir "Diariamente" y luego editar la tarea después para agregar la repetición desde la pestaña "Desencadenadores" → Editar → "Repetir la tarea cada: 15 minutos, durante: 1 día".
4. Acción: **Iniciar un programa** → Programa/script: `C:\Users\Osvaldo Cerda\Downloads\TASCO\Inmobiliaria\Reportería\Directorio Inmobiliario\Rocas\auto_push.bat`
5. Finalizar. La tarea corre sola en segundo plano; si no hay cambios, el script no hace nada (mensaje "Sin cambios que publicar").

## 6. Activar GitHub Pages (para ver el reporte como página web)

1. En github.com, entra al repo → **Settings** → **Pages**.
2. En "Build and deployment" → Source: **Deploy from a branch**.
3. Branch: **master**, carpeta: **/ (root)** → **Save**.
4. En un par de minutos, el reporte queda visible en:
   **https://oecerda-ux.github.io/reporte-directorio-rocas/**

(El script ya se encarga de mantener actualizado `index.html`, que es el archivo que GitHub Pages sirve en la raíz.)

---

**Nota de seguridad:** si algún token de GitHub quedó expuesto en un chat (el tuyo o el de otro reporte), revócalo aunque ya no pienses usarlo — un token con permiso `repo` puede modificar o borrar cualquiera de tus repositorios.
