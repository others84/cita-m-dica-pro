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
    public static function alta(int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, int $idGenero, ?int $idMunicipio, string $observaciones = '', int $notificaEmail = 0, int $notificaWa = 0): int {
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
    public static function cambio(int $id, int $idClinica, string $apPat, string $apMat, string $nombre, string $direccion, string $tel, string $email, string $fechaNac, int $idGenero, ?int $idMunicipio, string $observaciones = '', int $notificaEmail = 0, int $notificaWa = 0, ?int $idClinicaEsperada = null): void {
        Database::log(sprintf('PACIENTE.cambio params id=%d clinica=%d ap=%s am=%s nom=%s dir=%s tel=%s email=%s fnac=%s gen=%d mun=%d',
            $id, $idClinica, self::s($apPat), self::s($apMat), self::s($nombre), self::s($direccion), self::s($tel), self::s($email), self::s($fechaNac), $idGenero, $idMunicipio));
        self::execute('EXEC citas.spCambioPaciente @id_PACIENTE=:id, @id_CLINICA=:c, @ap_paterno=:ap, @ap_materno=:am, @nombre=:n, @direccion=:d, @telefono=:t, @email=:e, @fecha_nacimiento=:f, @id_CATALOGO_GENERO=:g, @id_CATALOGO_MUNICIPIO=:m, @observaciones=:o, @notifica_email=:ne, @notifica_wa=:nw, @id_usuario=:u, @id_CLINICA_esperada=:ce', [
            ':id'=>$id, ':c'=>$idClinica, ':ap'=>self::s($apPat), ':am'=>self::s($apMat), ':n'=>self::s($nombre),
            ':d'=>self::s($direccion), ':t'=>self::s($tel), ':e'=>self::s($email), ':f'=>self::s($fechaNac), ':g'=>$idGenero,
            ':m'=>$idMunicipio, ':o'=>self::s($observaciones),
            ':ne'=>$notificaEmail ? 1 : 0, ':nw'=>$notificaWa ? 1 : 0,
            ':u'=>self::currentUserId(),
            ':ce'=>$idClinicaEsperada,
        ]);
    }
    public static function cambioObservaciones(int $id, string $observaciones): void {
        self::execute('EXEC citas.spCambioObservacionesPaciente @id_PACIENTE=:id, @observaciones=:o, @id_usuario=:u', [
            ':id'=>$id, ':o'=>self::s($observaciones), ':u'=>self::currentUserId(),
        ]);
    }
    public static function baja(int $id, ?int $idClinicaEsperada = null): void {
        self::execute('EXEC citas.spBajaPaciente @id_PACIENTE=:id, @id_usuario=:u, @id_CLINICA_esperada=:ce',
            [':id'=>$id, ':u'=>self::currentUserId(), ':ce'=>$idClinicaEsperada]);
    }

    /** Solo digitos de un telefono (para comparar celulares). */
    public static function soloDigitos(?string $tel): string {
        $d = preg_replace('/\D+/', '', (string)$tel);
        return (string)$d;
    }

    /**
     * Busca pacientes cuyo telefono coincida exactamente (comparando solo
     * digitos, ignorando lada 52 inicial). Uso: pagina publica de citas.
     * @return array<int,array<string,mixed>> una fila por clinica donde exista
     */
    public static function buscarPorTelefono(string $telefono): array {
        $bus = self::soloDigitos($telefono);
        if (strlen($bus) < 10) return [];
        $cola = substr($bus, -10);
        $out = [];
        foreach (self::listar() as $p) {
            $t = self::soloDigitos((string)($p['telefono'] ?? ''));
            if ($t === '' ) continue;
            if (substr($t, -10) === $cola) $out[] = $p;
        }
        return $out;
    }

    /**
     * Version segura de buscarPorTelefono para la pagina publica: NO expone
     * datos personales, solo el identificador, la clinica y los destinos de
     * contacto enmascarados para pedir el codigo de verificacion.
     * @return array<int,array{id_PACIENTE:int,id_CLINICA:int,clinica:string,email:string,email_mask:string,telefono:string,telefono_mask:string}>
     */
    public static function resumenPorTelefono(string $telefono): array {
        $out = [];
        foreach (self::buscarPorTelefono($telefono) as $p) {
            $email = trim((string)($p['email'] ?? ''));
            $tel   = trim((string)($p['telefono'] ?? ''));
            $out[] = [
                'id_PACIENTE'   => (int)$p['id_PACIENTE'],
                'id_CLINICA'    => (int)$p['id_CLINICA'],
                'clinica'       => (string)($p['clinica'] ?? ''),
                'email'         => $email,
                'email_mask'    => self::mascaraEmail($email),
                'telefono'      => $tel,
                'telefono_mask' => self::mascaraTelefono($tel),
            ];
        }
        return $out;
    }

    /** ana.lopez@gmail.com -> a******z@gmail.com */
    public static function mascaraEmail(string $email): string {
        $at = strpos($email, '@');
        if ($at === false || $at < 1) return '';
        $usr = substr($email, 0, $at);
        $dom = substr($email, $at);
        if (strlen($usr) <= 2) return substr($usr, 0, 1) . '***' . $dom;
        return substr($usr, 0, 1) . str_repeat('*', max(3, strlen($usr) - 2)) . substr($usr, -1) . $dom;
    }

    /** 2221234567 -> ••••••4567 */
    public static function mascaraTelefono(string $tel): string {
        $d = self::soloDigitos($tel);
        if (strlen($d) < 4) return '';
        return str_repeat('•', max(2, strlen($d) - 4)) . substr($d, -4);
    }
}
