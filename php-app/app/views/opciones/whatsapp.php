<div class="card" style="max-width:640px">
  <h2 style="margin-top:0;color:var(--c5)">Configuración de WhatsApp</h2>
  <p style="color:var(--c4);margin-top:0">Conexión con Evolution API (WhatsApp vinculado por código QR) desde la cual el sistema enviará los códigos de verificación de la cita en línea.</p>
  <form method="post" action="<?= url('opciones/whatsappGuardar') ?>" class="form-grid"><?= csrf_field() ?>
    <label>URL de Evolution API
      <input type="url" name="api_url" maxlength="500" required value="<?= htmlspecialchars((string)($cfg['api_url'] ?? 'http://127.0.0.1:8081')) ?>" placeholder="http://127.0.0.1:8081">
    </label>
    <label>Nombre de la instancia
      <input type="text" name="instancia" maxlength="60" pattern="[A-Za-z0-9_\-]{1,60}" required value="<?= htmlspecialchars((string)($cfg['instancia'] ?? 'SGCO')) ?>" placeholder="SGCO">
    </label>
    <label>API Key
      <input type="password" name="api_key" maxlength="1000" autocomplete="new-password"<?= empty($cfg['tiene_api_key']) ? ' required' : '' ?> placeholder="<?= !empty($cfg['tiene_api_key']) ? 'Dejar vacío para conservar la actual' : 'AUTHENTICATION_API_KEY' ?>">
    </label>
    <label>Lada del país
      <input type="text" name="lada_default" inputmode="numeric" pattern="[1-9][0-9]{0,4}" maxlength="5" required value="<?= htmlspecialchars((string)($cfg['lada_default'] ?? '52')) ?>">
    </label>
    <label>Activo
      <select name="activo">
        <option value="1"<?= (int)($cfg['activo'] ?? 1) === 1 ? ' selected' : '' ?>>Sí</option>
        <option value="0"<?= (int)($cfg['activo'] ?? 1) === 0 ? ' selected' : '' ?>>No</option>
      </select>
    </label>
    <p class="ayuda" style="grid-column:1/-1;color:var(--c4)">El celular debe estar vinculado a la instancia (WhatsApp → Dispositivos vinculados) y con internet. El mensaje se envía como texto, sin plantillas.</p>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit">Guardar configuración</button>
    </div>
  </form>
</div>

<div class="card" style="max-width:640px;margin-top:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Probar envío</h3>
  <form method="post" action="<?= url('opciones/whatsappPrueba') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Enviar código de prueba al número
      <input type="text" name="destino" maxlength="20" required placeholder="2221234567">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn btn-sec" type="submit">Enviar prueba</button>
    </div>
  </form>
</div>
