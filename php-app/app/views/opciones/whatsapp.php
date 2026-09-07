<div class="card" style="max-width:640px">
  <h2 style="margin-top:0;color:var(--c5)">Configuración de WhatsApp</h2>
  <p style="color:var(--c4);margin-top:0">Cuenta de WhatsApp Cloud API (Meta) desde la cual el sistema enviará los códigos de verificación de la cita en línea.</p>
  <form method="post" action="<?= url('opciones/whatsappGuardar') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Phone Number ID
      <input type="text" name="phone_number_id" maxlength="60" required value="<?= htmlspecialchars((string)($cfg['phone_number_id'] ?? '')) ?>" placeholder="123456789012345">
    </label>
    <label>WhatsApp Business Account ID (WABA)
      <input type="text" name="waba_id" maxlength="60" value="<?= htmlspecialchars((string)($cfg['waba_id'] ?? '')) ?>" placeholder="987654321098765">
    </label>
    <label>Token de acceso permanente
      <input type="password" name="token" maxlength="1000" autocomplete="new-password" placeholder="<?= !empty($cfg) ? 'Dejar vacío para conservar el actual' : 'EAAG...' ?>">
    </label>
    <label>Versión de la API
      <input type="text" name="api_version" maxlength="10" required value="<?= htmlspecialchars((string)($cfg['api_version'] ?? 'v21.0')) ?>">
    </label>
    <label>Plantilla del código
      <input type="text" name="plantilla" maxlength="120" required value="<?= htmlspecialchars((string)($cfg['plantilla'] ?? 'codigo_verificacion')) ?>">
    </label>
    <label>Idioma de la plantilla
      <input type="text" name="plantilla_idioma" maxlength="20" required value="<?= htmlspecialchars((string)($cfg['plantilla_idioma'] ?? 'es_MX')) ?>">
    </label>
    <label>Lada del país
      <input type="text" name="lada_default" maxlength="5" required value="<?= htmlspecialchars((string)($cfg['lada_default'] ?? '52')) ?>">
    </label>
    <label>Activo
      <select name="activo">
        <option value="1"<?= (int)($cfg['activo'] ?? 1) === 1 ? ' selected' : '' ?>>Sí</option>
        <option value="0"<?= (int)($cfg['activo'] ?? 1) === 0 ? ' selected' : '' ?>>No</option>
      </select>
    </label>
    <p class="ayuda" style="grid-column:1/-1;color:var(--c4)">La plantilla debe estar aprobada en Meta como plantilla de autenticación y recibir el código como primer parámetro.</p>
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
