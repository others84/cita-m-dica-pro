<div class="card" style="max-width:640px">
  <h2 style="margin-top:0;color:var(--c5)">Configuración de correo</h2>
  <p style="color:var(--c4);margin-top:0">Cuenta desde la cual el sistema enviará los avisos (por ejemplo, el enlace para restablecer contraseñas).</p>
  <form method="post" action="<?= url('opciones/correoGuardar') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Servidor SMTP
      <input type="text" name="host" maxlength="150" required value="<?= htmlspecialchars((string)($cfg['host'] ?? '')) ?>" placeholder="smtp.midominio.com">
    </label>
    <label>Puerto
      <input type="number" name="puerto" min="1" max="65535" required value="<?= htmlspecialchars((string)($cfg['puerto'] ?? 587)) ?>">
    </label>
    <label>Cifrado
      <?php $cif = strtolower((string)($cfg['cifrado'] ?? 'tls')); ?>
      <select name="cifrado">
        <option value="tls"<?= $cif === 'tls' ? ' selected' : '' ?>>STARTTLS (587)</option>
        <option value="ssl"<?= $cif === 'ssl' ? ' selected' : '' ?>>SSL (465)</option>
        <option value="ninguno"<?= $cif === 'ninguno' ? ' selected' : '' ?>>Sin cifrado (25)</option>
      </select>
    </label>
    <label>Usuario SMTP
      <input type="text" name="usuario" maxlength="150" value="<?= htmlspecialchars((string)($cfg['usuario'] ?? '')) ?>" autocomplete="off">
    </label>
    <label>Contraseña SMTP
      <input type="password" name="password" maxlength="200" autocomplete="new-password" placeholder="<?= !empty($cfg) ? 'Dejar vacío para conservar la actual' : '' ?>">
    </label>
    <label>Correo remitente
      <input type="email" name="remitente" maxlength="120" required value="<?= htmlspecialchars((string)($cfg['remitente'] ?? '')) ?>" placeholder="no-reply@midominio.com">
    </label>
    <label>Nombre del remitente
      <input type="text" name="remitente_nombre" maxlength="120" required value="<?= htmlspecialchars((string)($cfg['remitente_nombre'] ?? 'Citas Médicas')) ?>">
    </label>
    <label>Activo
      <select name="activo">
        <option value="1"<?= (int)($cfg['activo'] ?? 1) === 1 ? ' selected' : '' ?>>Sí</option>
        <option value="0"<?= (int)($cfg['activo'] ?? 1) === 0 ? ' selected' : '' ?>>No</option>
      </select>
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit">Guardar configuración</button>
    </div>
  </form>
</div>

<div class="card" style="max-width:640px;margin-top:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Probar envío</h3>
  <form method="post" action="<?= url('opciones/correoPrueba') ?>" class="form-grid"><?= csrf_field() ?>
    <label>Enviar correo de prueba a
      <input type="email" name="destino" maxlength="120" required placeholder="tucorreo@dominio.com">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn btn-sec" type="submit">Enviar prueba</button>
    </div>
  </form>
</div>
