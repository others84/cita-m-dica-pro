# Fix the demo site's login error (missing files on the demo server)

## What the log shows
The demo site's diagnostic log reports this error on every login:

`Failed opening required '/var/www/citas-demo/app/models/LoginIntentoModel.php'`

The demo server has the new login page (with lockout after 5 attempts), but it does not have the files that page depends on. These files came with the security update and were never copied to the demo folder. The sessions are working now. The `storage/sessions` folder was created with the right permissions.

## No code changes needed
The files already exist in the project. They only need to be copied to the server.

## Files to copy to /var/www/citas-demo (and to /var/www/citas-live if they are missing there), in order
1. `php-app/app/models/LoginIntentoModel.php` (new): tracks failed attempts and lockouts
2. `php-app/app/core/AvisoBloqueo.php` (new): sends the lockout email
3. `php-app/app/controllers/AuthController.php`
4. `php-app/app/core/Controller.php`
5. `php-app/app/controllers/AsistentesController.php`, `MedicosController.php`, `OpcionesController.php`
6. The views that changed in the security update (assistant, doctor and user-password forms)

The simplest option is to copy the whole `app/` folder from the project over the demo's `app/` folder. `.env`, `storage/` and `public/` stay as they are.

## Database
Run `sql/patches/2026-10-10_bloqueo_login.sql` on `citasMedicasDEMO`, changing the first line to `USE citasMedicasDEMO`. If it isn't run, the next error will be "invalid object name" for the attempts table.

## Check
```bash
ls -l /var/www/citas-demo/app/models/LoginIntentoModel.php /var/www/citas-demo/app/core/AvisoBloqueo.php
sudo tail -n 5 /var/www/citas-demo/storage/logs/diagnostico-*.log
```
Then sign in at `/demo/auth/login`. No new FATAL lines should appear.
