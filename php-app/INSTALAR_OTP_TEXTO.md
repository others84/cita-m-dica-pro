# Mensaje editable del código de verificación por WhatsApp

## Archivos por prioridad

1. `2026-10-23_whatsapp_otp_texto.sql`: ejecutar en cada base antes de copiar PHP.
2. `app/models/ConfigWhatsappModel.php`: reemplazar.
3. `app/core/Whatsapp.php`: reemplazar.
4. `app/controllers/OpcionesController.php`: reemplazar.
5. `app/views/opciones/whatsapp.php`: reemplazar.

El paquete también incluye `tests/whatsapp_evolution_test.php` y esta guía. Las rutas son relativas a `php-app` o a la carpeta de instalación que contiene `app` y `public`.

## Instalación

Respalda la base y los cuatro archivos PHP. Primero prueba en DEMO (o tu instalación Windows) y después en LIVE. Requiere la estructura Evolution del paquete anterior: si aún no existe `CONFIG_WHATSAPP_EVOLUTION`, ejecuta primero `2026-10-23_whatsapp_evolution.sql`. No vuelvas a ejecutar ese script antiguo después del nuevo, porque restablecería los procedimientos anteriores.

Ejecuta el nuevo parche con una cuenta SQL que pueda alterar tablas y procedimientos; no incluye `USE` y conserva la configuración existente:

```bash
sqlcmd -S localhost,1433 -U sa -C -b -d citasMedicasDEMO -i 2026-10-23_whatsapp_otp_texto.sql
sqlcmd -S localhost,1433 -U sa -C -b -d CitasMedicas -i 2026-10-23_whatsapp_otp_texto.sql
```

En Windows puedes abrir el SQL en SQL Server Management Studio, seleccionar la base local correspondiente y ejecutarlo. No ejecutes en una base equivocada ni cambies la APP_KEY o las credenciales. Después reemplaza juntos los cuatro PHP.

## Uso

Como **Administrador de sistema → Configuración → Configuración de WhatsApp**, edita **Mensaje del código de verificación de la cita pública**.

- `{codigo}` es obligatorio: se sustituye por el código de cuatro dígitos.
- `{minutos}` es opcional: se sustituye por la vigencia real, actualmente 10 minutos.
- Solo estas variables están disponibles. El texto admite hasta 2000 caracteres.
- La vista previa usa `1234`, solo como ejemplo.
- Presiona **Guardar configuración**, vuelve a abrir la pantalla para verificar que el mensaje quedó guardado y después **Enviar prueba**.

La prueba usa el mensaje guardado, igual que la cita pública. El código de prueba no valida ninguna cita. Verifica la recepción real en un teléfono propio; luego prueba un paciente existente en la cita pública. No cambian los límites de 5 intentos, 5 envíos por hora ni la vigencia de 10 minutos. No afecta correo, mensajes manuales de confirmación ni la configuración antigua de Meta.

## Comprobaciones

Ejecutar `php tests/whatsapp_evolution_test.php` comprueba la validación, el cifrado y el recorrido guardar/leer/renderizar mediante un sustituto de conexión SQL. La sintaxis PHP también se revisó. La ejecución del parche y la recepción real requieren comprobarse en tu instalación con SQL Server y Evolution; no fueron verificadas desde este entorno.