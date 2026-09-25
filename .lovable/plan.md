# Contrato y aviso de privacidad por clínica, con firma digital al primer ingreso

## Qué se va a construir

1. **Plantillas precargadas (Administrador de Sistema)**
   - Nueva opción de menú "Plantillas legales" con dos plantillas base: *Contrato* y *Aviso de privacidad*.
   - Se editan con un editor visual en la página (negritas, cursivas, títulos, listas, alineación, tablas simples, enlaces) que genera HTML. Tiene vista previa.
   - Variables que se reemplazan automáticamente: `@@CLINICA`, `@@DIRECCION`, `@@EMAIL_CLINICA`, `@@TELEFONO_CLINICA`, `@@FECHA`, `@@USUARIO`, `@@NOMBRE_USUARIO`, `@@ROL`.
   - Se precargan textos de ejemplo (genéricos, deben ser revisados por su abogado).

2. **Documentos de cada clínica**
   - En el módulo Clínicas, nuevo botón "Contrato y aviso" por clínica.
   - Al entrar por primera vez se copian las plantillas vigentes; el Administrador de Sistema puede ajustarlas para esa clínica con el mismo editor, o "Recargar desde plantilla".
   - Cada vez que se guarda un cambio se crea una nueva versión (las versiones anteriores y sus firmas se conservan).
   - Al dar de alta una clínica nueva se le asignan automáticamente las plantillas vigentes.

3. **Firma al primer ingreso (Asistente, Médico, Administrador de Clínica)**
   - Tras iniciar sesión, si el usuario no ha aceptado la versión vigente del contrato y del aviso de su(s) clínica(s), se le muestra una pantalla con ambos documentos, casillas "He leído y acepto" y botón "Firmar y continuar".
   - No puede usar ninguna otra pantalla hasta aceptar (solo puede cerrar sesión).
   - Se registra: usuario, clínica, documento y versión, **fecha/hora (del servidor SQL)**, **IP** y navegador.
   - Una vez aceptado, ya no vuelve a aparecer. Solo reaparecería si el Administrador de Sistema publica una nueva versión del documento de esa clínica.
   - Usuarios con varias clínicas firman los documentos de cada clínica.
   - El Administrador de Sistema no firma.

4. **Consulta de firmas**
   - En "Contrato y aviso" de cada clínica, una tabla con quién firmó, versión, fecha/hora e IP, y quién está pendiente.

## Detalles técnicos

Base de datos (nuevo patch `php-app/sql/patches/2026-09-25_contratos_clinica.sql` + `schema.sql`), todo vía SPs y `LOG`:
- `citas.PLANTILLA_LEGAL` (id, tipo CONTRATO/AVISO, html, fecha_mod, id_usuario_mod) con 2 renglones semilla.
- `citas.DOCUMENTO_CLINICA` (id, id_CLINICA, tipo, version, html, vigente, fecha_alta, id_usuario).
- `citas.FIRMA_DOCUMENTO` (id, id_DOCUMENTO_CLINICA, id_USUARIOS, id_CLINICA, fecha_firma DEFAULT GETDATE(), ip, user_agent), único por (documento, usuario).
- SPs: `spRegresaPlantillas`, `spGuardaPlantilla`, `spRegresaDocumentosClinica`, `spGuardaDocumentoClinica` (versiona), `spRegresaDocumentosPendientes @id_usuario`, `spFirmaDocumento`, `spRegresaFirmasClinica`; `spAltaClinica` copia plantillas.

PHP, por prioridad:
1. `php-app/app/models/DocumentoLegalModel.php` (nuevo) — plantillas, documentos, pendientes, firmas.
2. `php-app/app/controllers/ContratosController.php` (nuevo) — plantillas y documentos por clínica (admin_sistema); `firmar()`/`aceptar()` para demás roles.
3. `php-app/app/core/Controller.php` — en `requireLogin()`, si el rol no es admin_sistema y hay pendientes (cacheado en sesión), redirigir a `contratos/firmar` (excepto esa ruta y logout).
4. `php-app/app/controllers/AuthController.php` — tras login calcular pendientes en sesión.
5. Vistas nuevas: `contratos/plantillas.php`, `contratos/clinica.php`, `contratos/firmar.php`, partial `_editor.php` (editor `contenteditable` + barra de herramientas en JS vanilla, sin dependencias externas).
6. `php-app/app/views/layout/header.php` — menú "Plantillas legales" (admin_sistema); ocultar menú en pantalla de firma.
7. `php-app/app/views/clinicas/_tabla.php` — botón "Contrato y aviso".
8. `php-app/public/assets/css/style.css` — estilos del editor y del documento a firmar.

Seguridad: HTML sanitizado en servidor con lista blanca de etiquetas/atributos (sin scripts, eventos ni `javascript:`); CSRF en formularios; IP tomada de `REMOTE_ADDR` (y `X-Forwarded-For` solo si se configura proxy de confianza).
