# Configuración de WhatsApp con Evolution API

Esta actualización sustituye en el aplicativo los campos de Meta por URL, instancia, API Key cifrada, lada y activo. Utiliza una tabla propia, `citas.CONFIG_WHATSAPP_EVOLUTION`, y dos procedimientos propios. No modifica pacientes, citas ni códigos OTP; tampoco borra la configuración antigua de Meta. Los enlaces manuales `wa.me` no cambian.

## Archivos por prioridad

1. `2026-10-23_whatsapp_evolution.sql`: ejecutar primero, una vez en LIVE y otra en DEMO.
2. `app/models/ConfigWhatsappModel.php`: reemplazar; lee y guarda la tabla nueva.
3. `app/core/Whatsapp.php`: reemplazar; envía texto mediante Evolution.
4. `app/controllers/OpcionesController.php`: reemplazar; guarda y prueba la configuración.
5. `app/views/opciones/whatsapp.php`: reemplazar; muestra URL, instancia, API Key, lada y activo.

El ZIP incluye solo esos archivos, esta guía y `tests/whatsapp_evolution_test.php` (prueba opcional, no va dentro de `public`). Las rutas son relativas a la carpeta que contiene `app`, `config` y `public` en cada instalación. No reemplaza `.env` ni Docker Compose.

## 1. Antes de instalar

- Respalda ambas bases y los cuatro archivos PHP actuales. Realiza primero la actualización y la prueba en DEMO.
- Conserva la misma `APP_KEY` existente en el `.env` de cada instalación: también cifra las contraseñas de correo. No la cambies para esta actualización. Si no existe, debe configurarse una clave de cifrado segura antes de guardar credenciales; no se incluye ninguna en el paquete.
- Evolution debe estar conectado y PHP debe tener las extensiones cURL y OpenSSL, además de su conexión SQL Server habitual.
- No publiques Evolution directamente en Internet: conserva el acceso local y el túnel SSH para su panel.

## 2. Ejecutar SQL en ambas bases

Desde la carpeta donde guardaste el archivo SQL, con una cuenta de SQL Server que tenga permisos para crear tablas, procedimientos y conceder EXECUTE:

```bash
sqlcmd -S localhost,1433 -U sa -C -b -d citasMedicasDEMO -i 2026-10-23_whatsapp_evolution.sql
sqlcmd -S localhost,1433 -U sa -C -b -d CitasMedicas -i 2026-10-23_whatsapp_evolution.sql
```

El comando solicita la contraseña; no la escribas en el archivo SQL ni en el comando. Si tu administrador SQL usa otra cuenta, sustituye `sa`. El script **no tiene USE**: actúa sobre la base seleccionada con `-d`. Puede volver a ejecutarse y no borra la configuración de Evolution ya guardada. Requiere que existan `citas.LOG` y el usuario de base `citasadmin`, como en la aplicación actual.

Crea una única configuración por base. No migra automáticamente ningún token: una credencial de Meta no sirve como API Key de Evolution. Si ya habías guardado Evolution en campos antiguos, captura de nuevo esos datos en la pantalla nueva.

## 3. Copiar los cuatro archivos PHP

Reemplaza los archivos de la lista en la carpeta de DEMO. Comprueba ahí la configuración y el envío antes de repetir en LIVE. Instala los cuatro juntos; no mezcles el modelo nuevo con el controlador antiguo.

## 4. Configurar desde el sistema

Entra como Administrador de sistema → Configuración de WhatsApp:

- URL: `http://127.0.0.1:8081` si PHP y Evolution están en el mismo VPS y este es el puerto configurado.
- Instancia: `SGCO`, respetando exactamente el nombre que aparece conectado en Evolution.
- API Key: la `AUTHENTICATION_API_KEY` real de tu Evolution; se guarda cifrada y nunca se muestra al volver a abrir la pantalla. Dejarla vacía al editar conserva la guardada.
- Lada: `52` para México.
- Activo: Sí.

Guarda, vuelve a abrir la pantalla para comprobar los datos y utiliza “Enviar prueba” con un teléfono propio. La confirmación significa que Evolution aceptó el mensaje: verifica también que llegue al teléfono. El código de prueba no valida una cita.

Después abre una cita pública de la clínica, busca el celular de un paciente existente y elige WhatsApp. Recibe el código, introdúcelo y confirma que se muestran sus datos. Los pacientes nuevos siguen sin requerir OTP. Los límites y vigencia del código no cambian.

DEMO y LIVE tienen configuraciones independientes, aunque pueden apuntar a la misma instancia. Las pruebas de DEMO envían mensajes reales: utiliza teléfonos propios o con consentimiento.

## Verificación y reversión

Se incluyen pruebas locales de validación, cifrado y contrato del modelo, ejecutables con `php tests/whatsapp_evolution_test.php`. No sustituyen una prueba con SQL Server y el teléfono: esa entrega real se debe comprobar en tu VPS.

Para revertir, restaura juntos los cuatro archivos PHP anteriores. La tabla anterior de Meta se conserva intacta. No elimines tablas OTP ni sus datos.

Evolution mediante QR no es la API oficial de WhatsApp; puede desconectarse o sufrir restricciones. Envía solo con consentimiento y conserva el correo como alternativa.