<?php
/**
 * Textos de ayuda por rol. Cada seccion: id, titulo, ruta (pantalla), pasos.
 * 'bienvenida' son los pasos clave que se muestran en el primer acceso.
 */
$__citas = [
    ['calendario', 'Calendario de citas', 'calendario', [
        'En esta pantalla se muestra tu calendario de forma gráfica para identificar fácilmente tus horarios disponibles. Puedes agruparlo por Día, Semana o Mes con los botones superiores.',
        'Las citas agendadas aparecen de color azul. Para consultar la información de una cita, da clic en ella y se abrirá una ventana con sus detalles.',
        'Para agendar una cita nueva, da clic en un horario libre y se abrirá la pantalla de Citas con esa fecha y hora ya capturadas.',
    ]],
    ['citas', 'Agendar y administrar citas', 'citas', [
        'Para crear una nueva cita, da clic en el botón "Nueva cita".',
        'Selecciona paciente, médico, consultorio y especialidad; agrega padecimientos y el precio se suma automáticamente (puedes modificarlo). Selecciona la fecha y hora de la cita.',
        'Indica las horas de anticipación del recordatorio por WhatsApp.',
        'Marca "En espera de un espacio anterior" si el paciente quiere adelantar su cita cuando otro paciente cancele y se libere un horario anterior al suyo.',
        'Presiona Alta una sola vez y espera el aviso "Generando la cita…".',
        'Desde Acciones puedes editar, enviar WhatsApp/correo, cancelar, marcar "No asistió" o borrar.',
    ]],
    ['citasmanana', 'Citas mañana y recordatorios', 'citasmanana', [
        'Esta opción muestra las citas del día siguiente para solicitar al paciente la confirmación de su asistencia.',
        'Usa el botón WhatsApp para enviar el recordatorio con el texto de notificación configurado.',
        'El número junto a "Citas" en el menú indica citas pendientes de notificar.',
    ]],
    ['citasespera', 'Citas en espera', 'citasespera', [
        'Esta opción muestra las citas de pacientes que desean un espacio anterior a su cita actual.',
        'Cuando se libere un horario, selecciona la cita del paciente que quiere adelantarla, usa el botón "Adelantar" y elige el nuevo día y hora del mismo médico.',
        'La cita sigue en espera hasta atenderse, cancelarse o marcarse "No asistió"; también puedes "Quitar de espera".',
    ]],
    ['pacientes', 'Pacientes e historial', 'pacientes', [
        'Da de alta, modifica o da de baja pacientes. Usa el campo de observaciones para dar seguimiento a su estado de salud.',
        'Da clic en el nombre de un paciente para ver su historial de citas.',
        'Configura las opciones de notificación del paciente para confirmar citas por WhatsApp y/o correo electrónico.',
        'Revisa el historial de asistencia de cada paciente.',
    ]],
    ['configuracion', 'Horario, días bloqueados y notificación (Configuración)', 'horarios', [
        'En "Apariencia" modifica el aspecto de la aplicación a tu gusto entre una serie de colores y tipos de letra.',
        'En "Horario de atención" define el horario de consultas y los periodos en los que no atiende el médico, como la hora de comida. Estos horarios se aplican al agendado desde la página pública.',
        'En "Días bloqueados" marca vacaciones o días sin consulta.',
        'En "Texto de notificación" personaliza el mensaje de WhatsApp para los recordatorios de cita.',
        'En "Cambiar contraseña" actualiza tu contraseña (mínimo 8 caracteres con letras y números).',
    ]],
];
$__reportes = ['reportes', 'Reportes', 'reportes/ingresos', [
    'Consulta ingresos por consulta, por citas y atención por periodo.',
]];

$AYUDA = [
    'asistente' => [
        'nombre' => 'Asistente',
        'bienvenida' => [
            'Revisa la agenda en Calendario de citas.',
            'Da clic en un horario libre para agendar una cita.',
            'Envía recordatorios desde Citas mañana.',
            'Consulta Citas en espera para adelantar citas.',
        ],
        'secciones' => $__citas,
    ],
    'medico' => [
        'nombre' => 'Médico',
        'bienvenida' => [
            'Configura tu horario de atención y tus padecimientos con precio.',
            'Revisa tu agenda en Calendario de citas.',
            'En Citas, presiona "Confirmar" al iniciar la consulta y "Atendida" al terminar.',
            'Consulta tus ingresos en Reportes.',
        ],
        'secciones' => array_merge($__citas, [
            ['atencion', 'Confirmar y atender', 'citas', [
                'Al presionar "Confirmar" se registra la hora real de inicio.',
                'Al presionar "Atendida" se registra la hora real de fin.',
            ]],
            ['padecimientos', 'Padecimientos y precios', 'padecimientos', [
                'En "Padecimientos" define la lista de padecimientos que trata el médico y el precio de cada uno.',
                'Al seleccionarlos en una cita, el precio se suma automáticamente.',
            ]],
            $__reportes,
        ]),
    ],
    'administrador' => [
        'nombre' => 'Administrador de clínica',
        'bienvenida' => [
            'Da de alta consultorios, especialidades, médicos y asistentes en Catálogos.',
            'Configura horarios y días bloqueados.',
            'Supervisa la agenda en Calendario y Citas.',
            'Revisa el desempeño en Reportes.',
        ],
        'secciones' => [
            ['catalogos', 'Catálogos de la clínica', 'medicos', [
                'Registra consultorios y especialidades.',
                'Da de alta médicos y asistentes con contraseña obligatoria (8+ caracteres, letras y números).',
                'Administra pacientes, padecimientos y usuarios de tu clínica.',
            ]],
            ['passwords', 'Contraseñas de usuarios', 'opciones/passwordUsuarios', [
                'Puedes restablecer la contraseña de médicos y asistentes de tu clínica.',
                'Tras 5 intentos fallidos de acceso, un usuario se bloquea 5 minutos y recibirás un correo.',
            ]],
            $__citas[0], $__citas[1], $__citas[3], $__citas[5],
            ['reportes', 'Reportes', 'reportes/ingresos', [
                'Ingresos, atención, Top 10 médicos y atención por especialidad.',
            ]],
        ],
    ],
    'admin_sistema' => [
        'nombre' => 'Administrador de sistema',
        'bienvenida' => [
            'Crea clínicas y asigna su administrador.',
            'Revisa las plantillas legales (contrato y aviso de privacidad).',
            'Configura correo, WhatsApp y aviso de accesos.',
            'Activa la protección de la cita pública.',
        ],
        'secciones' => [
            ['clinicas', 'Clínicas', 'clinicas', [
                'Crea y edita clínicas; cada clínica tiene un único administrador.',
                'En "Asignar clínicas a usuarios" relaciona usuarios con clínicas.',
                'En "Bloquear acceso a clínicas" suspende temporalmente una clínica.',
            ]],
            ['legales', 'Plantillas legales', 'contratos/plantillas', [
                'Edita el contrato y aviso de privacidad base.',
                'Cada usuario de clínica los firma en su primer acceso (se guarda fecha, hora e IP).',
            ]],
            ['comunicacion', 'Correo, WhatsApp y aviso de accesos', 'opciones/correo', [
                'Configura la cuenta de correo de salida y WhatsApp.',
                'En "Aviso de accesos" define destinatarios y texto del correo al entrar un administrador.',
            ]],
            ['antibot', 'Protección de la cita pública', 'opciones/antibot', [
                'Activa el CAPTCHA y ajusta los límites por IP y por celular.',
            ]],
            ['catalogos', 'Catálogos globales', 'catalogos/paises', [
                'Administra países, estados, municipios, géneros y estados de cita.',
            ]],
            ['reportes', 'Reportes', 'reportes/ingresos', [
                'Consulta indicadores de todas las clínicas.',
            ]],
        ],
    ],
];

/** Pantalla actual -> seccion de ayuda */
$AYUDA_MAPA = [
    'calendario' => 'calendario', 'citas' => 'citas', 'citasmanana' => 'citasmanana',
    'citasespera' => 'citasespera', 'pacientes' => 'pacientes', 'horarios' => 'configuracion',
    'diasbloqueados' => 'configuracion', 'mensajes' => 'configuracion', 'padecimientos' => 'padecimientos',
    'reportes' => 'reportes', 'clinicas' => 'clinicas', 'contratos' => 'legales',
    'medicos' => 'catalogos', 'asistentes' => 'catalogos', 'catalogos' => 'catalogos',
];
