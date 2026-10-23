<?php
require_once __DIR__ . '/../app/core/Whatsapp.php';
require_once __DIR__ . '/../app/models/ConfigWhatsappModel.php';
Database::$silencioso = true;
function check(bool $ok, string $message): void {
    if (!$ok) throw new RuntimeException($message);
}
function rejects(callable $fn): void {
    try { $fn(); } catch (Exception $e) { return; }
    throw new RuntimeException('Se acepto una configuracion invalida.');
}
Whatsapp::validarConfiguracion('http://127.0.0.1:8081', 'SGCO', '', '52');
rejects(fn() => Whatsapp::validarConfiguracion('file:///etc/passwd', 'SGCO', '', '52'));
rejects(fn() => Whatsapp::validarConfiguracion('https://user:pass@example.com', 'SGCO', '', '52'));
rejects(fn() => Whatsapp::validarConfiguracion('https://example.com?token=abc', 'SGCO', '', '52'));
rejects(fn() => Whatsapp::validarConfiguracion('https://example.com', '../instancia', '', '52'));
rejects(fn() => Whatsapp::validarConfiguracion('https://example.com', 'SGCO', "a\r\nb", '52'));
check(Whatsapp::normaliza('2221234567', '52') === '522221234567', 'Normalizacion mexicana incorrecta.');
check(Whatsapp::normaliza('+52 222 123 4567', '52') === '522221234567', 'Se duplico la lada.');

class EvolutionStatement extends PDOStatement {
    public function __construct(private EvolutionPDO $db) {}
    public function execute(?array $params = null): bool { $this->db->params = $params ?? []; return true; }
    public function fetchAll(int $mode = PDO::FETCH_DEFAULT, mixed ...$args): array { return $this->db->rows; }
    public function nextRowset(): bool { return false; }
}
class EvolutionPDO extends PDO {
    public string $sql = '';
    public array $params = [];
    public array $rows = [];
    public function __construct() {}
    public function prepare(string $query, array $options = []): PDOStatement|false {
        $this->sql = $query;
        return new EvolutionStatement($this);
    }
}
$db = new EvolutionPDO();
$pdo = new ReflectionProperty(Database::class, 'pdo');
$pdo->setValue(null, $db);
putenv('APP_KEY=' . bin2hex(random_bytes(32)));
$key = bin2hex(random_bytes(32));
ConfigWhatsappModel::guardar('http://127.0.0.1:8081', 'SGCO', $key, '52', true);
check(str_starts_with($db->sql, 'EXEC citas.spGuardaConfigWhatsappEvolution '), 'Se uso el procedimiento de Meta.');
check($db->params[':url'] === 'http://127.0.0.1:8081' && $db->params[':ins'] === 'SGCO', 'Campos Evolution incorrectos.');
check($db->params[':key'] !== $key && ConfigCorreoModel::descifrar($db->params[':key']) === $key, 'API Key no cifrada.');
$encrypted = $db->params[':key'];
$db->rows = [['api_url' => 'http://127.0.0.1:8081', 'instancia' => 'SGCO', 'api_key_cifrada' => $encrypted, 'lada_default' => '52', 'activo' => 1]];
check(ConfigWhatsappModel::obtener()['api_key'] === $key, 'No se recupero la clave guardada.');
check(ConfigWhatsappModel::disponible(), 'Configuracion completa no disponible.');
$db->rows[0]['activo'] = 0;
check(!ConfigWhatsappModel::disponible(), 'Configuracion desactivada disponible.');
ConfigWhatsappModel::guardar('http://127.0.0.1:8081', 'SGCO', '', '52', false);
check($db->params[':key'] === '', 'No se conserva la clave al dejarla vacia.');
echo "OK: validacion, campos Evolution, cifrado, lectura, conservacion de clave y disponibilidad.\n";