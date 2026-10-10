# Corrección de vulnerabilidades de cuentas y acceso

## 1. Cambio de contraseña de otros usuarios (Administrador de clínica)
- "Contraseña usuarios" solo mostrará y aceptará **asistentes y médicos** de sus clínicas. Se excluyen otros administradores de clínica, administradores de sistema y el propio administrador (él usa "Cambiar contraseña").
- Al guardar se vuelve a revisar el rol del usuario elegido en el servidor; si no es asistente/médico se rechaza y se registra en la bitácora.

## 2. Pantalla Asistentes: solo asistentes
- La revisión de permiso exigirá que el usuario sea de rol **asistente** además de pertenecer a una clínica del administrador. Aplica a guardar (editar datos, rol y contraseña), activar, desactivar, asignar clínica y quitar clínica.
- Mismo criterio en Médicos: el usuario debe ser de rol **médico**.

## 3. Quitar clínica sin verificar dueño (Asistentes y Médicos)
- Antes de borrar la asignación, se confirma que el número de asignación recibido aparece en las clínicas de **ese** asistente/médico y que corresponde a la clínica indicada, que a su vez debe ser del administrador. Si no coincide se rechaza y se registra.

## 4. Límite de intentos en el inicio de sesión
- 5 intentos fallidos seguidos → el usuario queda bloqueado **5 minutos**. Durante el bloqueo se muestra "Usuario bloqueado temporalmente, intenta en X minutos" (sin revelar si la contraseña era correcta).
- Un acceso correcto reinicia el contador.
- Al bloquearse, se envía un correo a los **administradores de clínica** de las clínicas del usuario (usando la cuenta de Configuración de correo), con usuario, fecha, hora e IP. Si el bloqueado es administrador de clínica o de sistema, se avisa también al correo de "Aviso de accesos". Si el correo falla, queda en la bitácora.
- El contador vive en la base de datos (no en la sesión), así no se evita borrando cookies.

## 5. Política de contraseñas
- Mínimo **8 caracteres**, con al menos una letra y un número, en: alta de asistentes, alta de médicos, alta en catálogo de usuarios, cambiar mi contraseña, contraseña de usuarios y restablecer por correo.
- Al **crear** un usuario la contraseña es obligatoria (ya no se acepta vacía). Al editar, vacío sigue significando "no cambiar".
- El procedimiento de alta en la base también rechazará contraseña vacía como segunda barrera.
- Los formularios mostrarán la regla y validarán antes de enviar.

## Archivos a modificar, por prioridad
1. `php-app/sql/patches/2026-10-10_bloqueo_login.sql` (nuevo; ejecutar primero en `CitasMedicas` y `CitasMedicasDEMO`): tabla de intentos fallidos, procedimientos para registrar/consultar/reiniciar, y validación de contraseña vacía en el alta de usuario.
2. `php-app/app/controllers/AuthController.php` — bloqueo tras 5 intentos y aviso por correo.
3. `php-app/app/core/AvisoBloqueo.php` (nuevo) — arma y envía el correo de bloqueo.
4. `php-app/app/models/LoginIntentoModel.php` (nuevo).
5. `php-app/app/core/Controller.php` — función común para validar la contraseña.
6. `php-app/app/controllers/OpcionesController.php` — filtro por rol en contraseña de usuarios y nueva regla.
7. `php-app/app/controllers/AsistentesController.php` — exigir rol asistente, validar quitar clínica, contraseña obligatoria al crear.
8. `php-app/app/controllers/MedicosController.php` — lo mismo con rol médico.
9. `php-app/app/controllers/CatalogosController.php` — contraseña obligatoria en alta de usuarios.
10. Vistas: `opciones/password_usuarios.php`, `opciones/cambiar_password.php`, `auth/restablecer.php`, `asistentes/index.php`, `medicos/index.php`, `catalogos/usuarios.php` — regla mínima visible.
11. `php-app/sql/schema.sql` — agregar el parche al final.

## Nota
Las contraseñas actuales de 4 a 7 caracteres seguirán funcionando para entrar; la regla aplica al crear o cambiar una contraseña.
