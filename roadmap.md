# Evolution API
- [x] Corregir desplazamiento de cita pública hacia Tus datos para pacientes nuevos; comprobado en navegador con una página de prueba en celular, tableta y escritorio. Pendiente probarlo en LIVE/DEMO.
- [x] Preparar script completo de SQL Server con los cambios hasta el 23 de octubre de 2026; cobertura estatica verificada, ejecucion SQL pendiente en el servidor.
- [x] Agregar texto OTP editable en Configuración de WhatsApp, con parche SQL y pruebas.
- [x] Crear configuración SQL propia para Evolution sin reutilizar campos de Meta.
- [x] Adaptar modelo, envío y pantalla de configuración.
- [x] Probar PHP, cifrado y contrato del modelo; entregar archivos con instrucciones para LIVE y DEMO.
- [ ] Verificar SQL y recepción real de OTP: requiere ejecutar el paquete en el VPS del usuario.
- [x] Variables @@RFC_MEDICO y @@CEDULA en contratos: columnas rfc/cedula en USUARIOS, captura en catalogo de medicos y sustitucion al firmar. Sintaxis PHP validada; pendiente aplicar 2026-10-28_medico_rfc_cedula.sql en LIVE/DEMO.