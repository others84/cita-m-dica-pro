<?php
require_once __DIR__ . '/../core/Model.php';
class ReporteModel extends Model {
    public static function ingresosPorMedico(?int $idClinica = null, ?string $desde = null, ?string $hasta = null): array {
        return self::query(
            'EXEC citas.spReporteIngresosPorMedico @id_CLINICA=:c, @fecha_desde=:d, @fecha_hasta=:h',
            [':c'=>$idClinica, ':d'=>$desde, ':h'=>$hasta]
        );
    }
}