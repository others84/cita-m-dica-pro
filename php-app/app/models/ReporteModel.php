<?php
require_once __DIR__ . '/../core/Model.php';
class ReporteModel extends Model {
    public static function ingresosPorMedico(): array {
        return self::query('SELECT * FROM citas.vwIngresosPorMedico');
    }
    public static function citasDelDia(): array {
        return self::query('SELECT * FROM citas.vwCitasDelDia');
    }
}