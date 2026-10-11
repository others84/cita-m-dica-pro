<?php
/**
 * Devuelve el marcado SVG de un ícono de servicio según su clave.
 * Claves disponibles: consulta, pediatria, obstetricia, general (por defecto)
 */
function icono_servicio($clave) {
    $iconos = array(
        'consulta' => '<svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 3v6a4 4 0 0 0 8 0V3"/><path d="M20 10v2a8 8 0 0 1-16 0v-2"/><circle cx="20" cy="8" r="2"/></svg>',
        'pediatria' => '<svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="13" r="7"/><path d="M9 13a3 3 0 0 0 6 0"/><path d="M9 6c0-1.5 1-2.5 1-2.5M15 6c0-1.5-1-2.5-1-2.5"/></svg>',
        'obstetricia' => '<svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21c-4-3-8-6.5-8-11a5 5 0 0 1 9-3 5 5 0 0 1 9 3c0 4.5-4 8-8 11z"/><path d="M6 12h2l1.5-2.5L11 15l1.5-3H16"/></svg>',
    );
    $general = '<svg viewBox="0 0 24 24" fill="none" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s-7-4.35-9.5-8.5C.7 9 2 5 6 5c2 0 3.5 1.2 4 2.5.5-1.3 2-2.5 4-2.5 4 0 5.3 4 3.5 7.5C19 16.65 12 21 12 21z"/></svg>';
    return isset($iconos[$clave]) ? $iconos[$clave] : $general;
}
