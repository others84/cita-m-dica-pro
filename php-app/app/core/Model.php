<?php
require_once __DIR__ . '/Database.php';

class Model {
    /**
     * Ejecuta un SP y devuelve todas las filas del primer resultset.
     * $params: array asociativo [':nombre' => valor] o posicional [val,val,...]
     * $sql: cadena con la llamada, ej: "EXEC citas.spRegresaCitas @id_MEDICO=:m, @fecha_desde=:fd, @fecha_hasta=:fh"
     */
    protected static function query(string $sql, array $params = []): array {
        try {
            $stmt = Database::pdo()->prepare($sql);
            $stmt->execute($params);
            $rows = $stmt->fetchAll();
            return $rows ?: [];
        } catch (Throwable $e) {
            Database::log('query ERR: ' . $e->getMessage() . ' | SQL=' . $sql);
            throw $e;
        }
    }

    protected static function execute(string $sql, array $params = []): void {
        try {
            $stmt = Database::pdo()->prepare($sql);
            $stmt->execute($params);
            while ($stmt->nextRowset()) { /* drain */ }
        } catch (Throwable $e) {
            Database::log('execute ERR: ' . $e->getMessage() . ' | SQL=' . $sql);
            throw $e;
        }
    }

    /**
     * Ejecuta SP con parametro OUTPUT @id_nuevo. Devuelve el INT generado.
     */
    protected static function executeWithOutput(string $spName, array $bindings): int {
        $pdo = Database::pdo();
        $names = array_keys($bindings);
        $args = implode(', ', array_map(fn($n) => $n . '=' . $n, $names));
        $sql = "DECLARE @id_nuevo INT; EXEC citas.$spName $args, @id_nuevo=@id_nuevo OUTPUT; SELECT @id_nuevo AS id_nuevo;";
        try {
            $stmt = $pdo->prepare($sql);
            foreach ($bindings as $k => $v) {
                $stmt->bindValue($k, $v);
            }
            $stmt->execute();
            do {
                $row = $stmt->fetch();
                if ($row && isset($row['id_nuevo'])) return (int)$row['id_nuevo'];
            } while ($stmt->nextRowset());
            return 0;
        } catch (Throwable $e) {
            Database::log("executeWithOutput ERR ($spName): " . $e->getMessage());
            throw $e;
        }
    }

    protected static function currentUserId(): int {
        $id = $_SESSION['user']['id_USUARIOS'] ?? 0;
        $id = (int)$id;
        if ($id < 0) $id = 0;
        if ($id > 255) $id = 255;
        return $id;
    }
}