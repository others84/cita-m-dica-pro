<?php
/**
 * Fallback minimo para servidores sin la extension mbstring.
 * Solo se definen las funciones que usa el sistema.
 */
if (!function_exists('mb_strlen')) {
    function mb_strlen($s, $enc = null) { return strlen((string)$s); }
}
if (!function_exists('mb_substr')) {
    function mb_substr($s, $start, $length = null, $enc = null) {
        return $length === null ? substr((string)$s, $start) : substr((string)$s, $start, $length);
    }
}
if (!function_exists('mb_strtolower')) {
    function mb_strtolower($s, $enc = null) { return strtolower((string)$s); }
}
if (!function_exists('mb_strtoupper')) {
    function mb_strtoupper($s, $enc = null) { return strtoupper((string)$s); }
}
if (!function_exists('mb_strpos')) {
    function mb_strpos($h, $n, $off = 0, $enc = null) { return strpos((string)$h, (string)$n, $off); }
}
if (!function_exists('mb_str_split')) {
    function mb_str_split($s, $len = 1, $enc = null) { return str_split((string)$s, max(1, (int)$len)); }
}
