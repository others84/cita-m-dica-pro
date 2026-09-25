<?php
require_once __DIR__ . '/../core/Model.php';

/** Plantillas legales, documentos por clinica (versionados) y firmas. */
class DocumentoLegalModel extends Model {
    public const TIPOS = ['CONTRATO' => 'Contrato', 'AVISO' => 'Aviso de privacidad'];

    public static function plantillas(): array {
        $out = [];
        foreach (self::query('EXEC citas.spRegresaPlantillas') as $r) $out[$r['tipo']] = $r;
        return $out;
    }

    public static function guardarPlantilla(string $tipo, string $html): void {
        self::execute('EXEC citas.spGuardaPlantilla @tipo=:t, @html=:h, @id_usuario=:u',
            [':t' => $tipo, ':h' => self::sanitizar($html), ':u' => self::currentUserId()]);
    }

    /** Documentos vigentes de la clinica indexados por tipo. */
    public static function vigentes(int $idClinica): array {
        $out = [];
        foreach (self::query('EXEC citas.spRegresaDocumentosClinica @id_CLINICA=:c, @todas=0', [':c' => $idClinica]) as $r) {
            $out[$r['tipo']] = $r;
        }
        return $out;
    }

    public static function historial(int $idClinica): array {
        return self::query('EXEC citas.spRegresaDocumentosClinica @id_CLINICA=:c, @todas=1', [':c' => $idClinica]);
    }

    public static function publicar(int $idClinica, string $tipo, string $html): void {
        self::execute('EXEC citas.spGuardaDocumentoClinica @id_CLINICA=:c, @tipo=:t, @html=:h, @id_usuario=:u',
            [':c' => $idClinica, ':t' => $tipo, ':h' => self::sanitizar($html), ':u' => self::currentUserId()]);
    }

    /** Si la clinica no tiene documentos, copia las plantillas vigentes. */
    public static function asegurar(int $idClinica): void {
        if ($idClinica <= 0) return;
        $vig = self::vigentes($idClinica);
        $pl = null;
        foreach (array_keys(self::TIPOS) as $t) {
            if (isset($vig[$t])) continue;
            $pl = $pl ?? self::plantillas();
            if (!empty($pl[$t]['html'])) self::publicar($idClinica, $t, (string)$pl[$t]['html']);
        }
    }

    public static function pendientes(int $idUsuario): array {
        return self::query('EXEC citas.spRegresaDocumentosPendientes @id_USUARIOS=:u', [':u' => $idUsuario]);
    }

    public static function firmar(int $idDocumento, int $idUsuario, string $ip, string $ua): void {
        self::execute('EXEC citas.spFirmaDocumento @id_DOCUMENTO_CLINICA=:d, @id_USUARIOS=:u, @ip=:ip, @user_agent=:ua, @id_usuario=:iu',
            [':d' => $idDocumento, ':u' => $idUsuario, ':ip' => substr($ip, 0, 45), ':ua' => substr($ua, 0, 400), ':iu' => self::currentUserId()]);
    }

    public static function firmas(int $idClinica): array {
        return self::query('EXEC citas.spRegresaFirmasClinica @id_CLINICA=:c', [':c' => $idClinica]);
    }

    /** Reemplaza @@VARIABLES (valores escapados). */
    public static function render(string $html, array $vars): string {
        $rep = [];
        foreach ($vars as $k => $v) $rep['@@' . $k] = htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
        // Las mas largas primero para no pisar prefijos.
        uksort($rep, fn($a, $b) => strlen($b) - strlen($a));
        return strtr($html, $rep);
    }

    /** Sanitiza HTML con lista blanca de etiquetas y atributos. */
    public static function sanitizar(string $html): string {
        $tags = ['p','br','b','strong','i','em','u','s','h1','h2','h3','h4','ul','ol','li','blockquote',
                 'table','thead','tbody','tr','th','td','a','span','div','hr'];
        if (!class_exists('DOMDocument')) {
            $html = strip_tags($html, '<' . implode('><', $tags) . '>');
            $html = preg_replace('/\s(on\w+|style|class|id)\s*=\s*("[^"]*"|\'[^\']*\'|[^\s>]+)/i', '', $html);
            return preg_replace('/javascript\s*:/i', '', $html);
        }
        $doc = new DOMDocument();
        libxml_use_internal_errors(true);
        $doc->loadHTML('<?xml encoding="UTF-8"><div id="__root">' . $html . '</div>', LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        libxml_clear_errors();
        $root = $doc->getElementById('__root');
        if (!$root) return '';
        self::limpiarNodo($root, $tags);
        $out = '';
        foreach ($root->childNodes as $n) $out .= $doc->saveHTML($n);
        return $out;
    }

    private static function limpiarNodo(DOMNode $node, array $tags): void {
        for ($i = $node->childNodes->length - 1; $i >= 0; $i--) {
            $c = $node->childNodes->item($i);
            if ($c instanceof DOMElement) {
                $tag = strtolower($c->nodeName);
                if (in_array($tag, ['script','style','iframe','object','embed','form','input','textarea','select','button','link','meta'], true)) {
                    $node->removeChild($c); continue;
                }
                self::limpiarNodo($c, $tags);
                if (!in_array($tag, $tags, true)) {
                    while ($c->firstChild) $node->insertBefore($c->firstChild, $c);
                    $node->removeChild($c); continue;
                }
                $permitidos = ['a' => ['href'], 'td' => ['colspan','rowspan'], 'th' => ['colspan','rowspan']];
                $keep = $permitidos[$tag] ?? [];
                $align = null;
                if ($c->hasAttribute('style') && preg_match('/text-align\s*:\s*(left|right|center|justify)/i', $c->getAttribute('style'), $m)) $align = strtolower($m[1]);
                if ($c->hasAttribute('align') && preg_match('/^(left|right|center|justify)$/i', $c->getAttribute('align'))) $align = strtolower($c->getAttribute('align'));
                for ($j = $c->attributes->length - 1; $j >= 0; $j--) {
                    $a = $c->attributes->item($j)->nodeName;
                    if (!in_array(strtolower($a), $keep, true)) $c->removeAttribute($a);
                }
                if ($align) $c->setAttribute('style', 'text-align:' . $align);
                if ($tag === 'a') {
                    $href = trim($c->getAttribute('href'));
                    if (!preg_match('#^(https?://|mailto:|tel:)#i', $href)) $c->removeAttribute('href');
                    else { $c->setAttribute('target', '_blank'); $c->setAttribute('rel', 'noopener noreferrer'); }
                }
            } elseif ($c instanceof DOMComment) {
                $node->removeChild($c);
            }
        }
    }
}
