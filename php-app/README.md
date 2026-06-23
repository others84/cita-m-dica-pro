# Sistema de Citas Médicas — PHP MVC + SQL Server 2022

Esqueleto generado como referencia. **No se ejecuta dentro del preview de Lovable** (Lovable corre TypeScript/React, no PHP). Lleva esta carpeta a un servidor con:

- PHP 8.1+ con extensiones `sqlsrv` y `pdo_sqlsrv` (Microsoft Drivers for PHP for SQL Server)
- Microsoft SQL Server 2022 Express
- Apache o IIS apuntando al directorio `public/` como DocumentRoot

## Pasos

1. Ejecutar `sql/schema.sql` en SQL Server (crea base, login, usuario, tablas, datos de prueba).
2. Editar `config/config.properties` con los datos reales de tu instancia.
3. Apuntar el servidor web al directorio `public/`.
4. Abrir `http://localhost/` → redirige al login.

## Usuarios de prueba

| Usuario    | Contraseña  | Rol           | Nombre                  |
|------------|-------------|---------------|-------------------------|
| asistente  | asistente1  | asistente     | Maria Fernanda Canales  |
| medico     | medico1     | medico        | Estefano Lopez Hamill   |
| admin      | admin1      | administrador | Victor Puig Morales     |

## Paleta

`#EAF6FF` `#BFDFFF` `#7FB6E6` `#3E7FB1` `#1E3A5F`
