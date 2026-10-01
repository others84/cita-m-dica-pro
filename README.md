# Cita Médica Pro

Actua como un diseñador web experto de paginas para gestión de sistemas de citas medicas poblano.

El sistema tendrá 3 roles: Administrador, medico y asistente

El sistema se dividirá en las siguientes paginas:

1.- Pagina de login, donde tendrá 2 campos: usuario y contraseña y un botón de acceso

2.- Si el usuario es asistente mostrará un menú con las opciones

	2.1.- Citas

		2.1.1. Agendar cita

		2.1.2. Modificar cita

		2.1.3. Cancelar cita

	2.2.- Ver calendario de citas

	2.3.- Opciones

		2.3.1 Cambiar contraseña

		2.3.2. Actualizar datos usuario

	2.4.- Cerrar sesión

3.- Si el usuario es medico, mostrará las opciones del asistente y las siguientes:

	3.1.- Asistentes

	3.2.- Reportes

		3.2.1. Ingresos 

4.- Si el usuario es administrador mostrará la pagina con las opciones para un asistente, un medico y las siguientes:

	4.1.- Medicos

	4.2.- Restaurar sistema

	4.3.- Roles

Para crear el calendario utiliza el componente eventCalendar que se encuentra en github https://github.com/vkurko/calendar, POr el momento utiliza datos de prueba.

Solo crea el esqueleto, no agregues contenido aún

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/d92238e6-1385-4e23-a6bf-b4a7a5532f85).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
