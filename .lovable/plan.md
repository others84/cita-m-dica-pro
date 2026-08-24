# Ayuda guiada en la página de cita pública

Objetivo: que una paciente con poca experiencia usando páginas web pueda agendar sola, sin preguntarse "¿y ahora qué hago?". Todo se resuelve con textos guía dentro de cada paso (sin ventanas nuevas, sin contacto externo).

## Principios de redacción

- Hablar de tú, en femenino cuando aplique, frases cortas de una idea.
- Cada paso empieza con una instrucción en imperativo: "Escribe tu número de celular".
- Evitar palabras de sistema: "registro", "campo", "seleccionar del combo", "clínica seleccionada". Se sustituyen por "tus datos", "escribe", "elige".
- Cada dato pedido lleva un ejemplo real ("Ejemplo: 2221234567").
- Numeración visible de pasos con un rótulo de avance: "Paso 2 de 5".

## Textos por paso

**Encabezado de la página**
- Título: "Agenda tu cita"
- Bajada: "Son 5 pasos cortos. Te tomará unos 3 minutos. Si te equivocas, puedes corregir antes de terminar."

**Paso 1 — Identifícate**
- "Escribe tu número de celular a 10 dígitos, sin espacios ni guiones. Ejemplo: 2221234567."
- "Si ya te has atendido con nosotros, tus datos aparecerán solos. Si es tu primera vez, te pediremos algunos datos más adelante."
- Botón "Buscar mis datos" con la nota: "Solo buscamos tu número; no verás datos de otras personas."
- Si el número no existe: "No encontramos tu número. No hay problema: elige tu clínica y llena tus datos abajo."
- Si aparece en varias clínicas: "Tu número está en más de una clínica. Elige a dónde quieres ir."

**Paso 2 — Clínica**
- "Elige la clínica a la que quieres ir y después el médico con el que deseas atenderte."
- Nota bajo consultorio y especialidad: "Estos dos datos se llenan solos. No tienes que hacer nada aquí."

**Paso 3 — Agenda del médico**
- "Aquí ves los horarios del médico. Los espacios en gris ya están ocupados por otra persona."
- "Toca un espacio en blanco del día que quieras. La fecha y la hora se escribirán solas más abajo."
- "Tu consulta dura 30 minutos."
- Si aún no hay médico elegido: "Primero elige un médico arriba para ver sus horarios."

**Paso 4 — Tus datos**
- "Llena tus datos para que el médico te identifique el día de tu cita."
- Ayudas por dato: fecha de nacimiento ("Día, mes y año en que naciste"), dirección ("Calle, número y colonia"), correo ("Si no tienes, pide ayuda en la clínica"), país/estado/municipio ("Elige primero el país; después aparecerán los estados").
- Observaciones: "Cuéntanos en pocas palabras por qué quieres la consulta. Ejemplo: 'revisión anual' o 'dolor desde hace una semana'. Lo que escribas solo lo ve tu médico."
- Avisos: "Marca cómo quieres que te recordemos tu cita."
- Si sus datos ya aparecieron: "Estos son los datos que tenemos tuyos. Revísalos; si algo cambió, avísanos al llegar a la clínica."

**Paso 5 — Horario y confirmación**
- "Revisa que la fecha y la hora sean las que elegiste en el calendario."
- Resumen antes del botón: "Tu cita: [día, fecha] a las [hora], con [médico], en [clínica]."
- Botón: "Confirmar mi cita".
- Mensaje de éxito: "¡Listo! Tu cita quedó agendada para [día, fecha] a las [hora] con [médico]. Llega 10 minutos antes. Si no puedes asistir, avisa a la clínica."

## Mensajes de error en lenguaje sencillo

Los errores actuales se reescriben con la misma idea: qué pasó + qué hacer.
- Campo vacío: "Falta tu [dato]. Escríbelo para continuar."
- Celular inválido: "El celular debe tener 10 números. Ejemplo: 2221234567."
- Horario ocupado: "Ese horario ya lo tomó otra persona. Elige otro espacio en blanco del calendario."
- Sin fecha/hora: "Aún no eliges horario. Toca un espacio en blanco del calendario."
- Sesión perdida: "Pasó mucho tiempo y se cerró la página. Empieza de nuevo, no se guardó nada."

## Detalles técnicos

Archivos a modificar (por prioridad):

1. `php-app/app/views/citapublica/index.php` — títulos de paso con "Paso X de 5", textos guía bajo cada encabezado, ayudas cortas debajo de los campos, resumen de la cita antes del botón y renombrado del botón a "Confirmar mi cita".
2. `php-app/app/controllers/CitapublicaController.php` — reescritura de los mensajes de validación y de error, y mensaje de éxito con fecha, hora y médico.
3. `php-app/public/assets/css/style.css` — estilos para las notas de ayuda (`.ayuda`), el rótulo de paso y el bloque de resumen, con letra más grande y buen contraste, respetando los temas actuales.

Sin cambios en base de datos. La lógica de agendado, validaciones de traslape y seguridad se conservan tal cual: solo cambian los textos y su presentación.
