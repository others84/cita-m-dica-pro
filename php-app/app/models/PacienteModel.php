<?php
require_once __DIR__ . '/../core/Model.php';
class PacienteModel extends Model {
    public static function listar(?int $idClinica = null): array {
        return self::query('EXEC citas.spRegresaPacientes @id_CLINICA=:c', [':c'=>$idClinica]);
    }
    /** Regresa un paciente puntual (todas las clinicas). */
    public static function obtener(int $id): ?array {
        foreach (self::listar() as $p) {
            if ((int)($p['id_PACIENTE'] ?? 0) === $id) return $p;
        }
        return null;
    }
    /** Todas las columnas de PACIENTE son NOT NULL: se envian cadenas, nunca NULL. */
    private static function s($v): string { return trim((string)$v); }
    public static function alta(int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, int $idGenero, int $idMunicipio, string $observaciones = '', int $notificaEmail = 0, int $notificaWa = 0): int {
        Database::log(sprintf('PACIENTE.alta params clinica=%d ap=%s am=%s nom=%s dir=%s tel=%s email=%s fnac=%s gen=%d mun=%d',
            $idClinica, self::s($apPat), self::s($apMat), self::s($nombre), self::s($direccion), self::s($tel), self::s($email), self::s($fechaNac), $idGenero, $idMunicipio));
        return self::executeWithOutput('spAltaPaciente', [
            '@id_CLINICA'=>$idClinica, '@ap_paterno'=>self::s($apPat), '@ap_materno'=>self::s($apMat), '@nombre'=>self::s($nombre),
            '@direccion'=>self::s($direccion), '@telefono'=>self::s($tel), '@email'=>self::s($email), '@fecha_nacimiento'=>self::s($fechaNac),
            '@id_CATALOGO_GENERO'=>$idGenero, '@id_CATALOGO_MUNICIPIO'=>$idMunicipio,
            '@observaciones'=>self::s($observaciones),
            '@notifica_email'=>$notificaEmail ? 1 : 0,
            '@notifica_wa'=>$notificaWa ? 1 : 0,
            '@id_usuario'=>self::currentUserId(),
        ]);
    }
    public static function cambio(int $id, int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, int $idGenero, int $idMunicipio, string $observaciones = '', int $notificaEmail = 0, int $notificaWa = 0): void {
        Database::log(sprintf('PACIENTE.cambio params id=%d clinica=%d ap=%s am=%s nom=%s dir=%s tel=%s email=%s fnac=%s gen=%d mun=%d',
            $id, $idClinica, self::s($apPat), self::s($apMat), self::s($nombre), self::s($direccion), self::s($tel), self::s($email), self::s($fechaNac), $idGenero, $idMunicipio));
        self::execute('EXEC citas.spCambioPaciente @id_PACIENTE=:id, @id_CLINICA=:c, @ap_paterno=:ap, @ap_materno=:am, @nombre=:n, @direccion=:d, @telefono=:t, @email=:e, @fecha_nacimiento=:f, @id_CATALOGO_GENERO=:g, @id_CATALOGO_MUNICIPIO=:m, @observaciones=:o, @notifica_email=:ne, @notifica_wa=:nw, @id_usuario=:u', [
            ':id'=>$id, ':c'=>$idClinica, ':ap'=>self::s($apPat), ':am'=>self::s($apMat), ':n'=>self::s($nombre),
            ':d'=>self::s($direccion), ':t'=>self::s($tel), ':e'=>self::s($email), ':f'=>self::s($fechaNac), ':g'=>$idGenero,
            ':m'=>$idMunicipio, ':o'=>self::s($observaciones),
            ':ne'=>$notificaEmail ? 1 : 0, ':nw'=>$notificaWa ? 1 : 0,
            ':u'=>self::currentUserId(),
        ]);
    }
    public static function cambioObservaciones(int $id, string $observaciones): void {
        self::execute('EXEC citas.spCambioObservacionesPaciente @id_PACIENTE=:id, @observaciones=:o, @id_usuario=:u', [
            ':id'=>$id, ':o'=>self::s($observaciones), ':u'=>self::currentUserId(),
        ]);
    }
    public static function baja(int $id): void { self::execute('EXEC citas.spBajaPaciente @id_PACIENTE=:id, @id_usuario=:u', [':id'=>$id, ':u'=>self::currentUserId()]); }
}