<?php $v = fn($k) => htmlspecialchars((string)($cfg[$k] ?? '')); ?>
<div class="card" style="max-width:640px">
  <h2 style="margin-top:0;color:var(--c5)">Protección de la cita pública</h2>
  <p style="color:var(--c4);margin-top:0">Evita que programas automáticos llenen la agenda o creen pacientes falsos. Los límites cuentan por conexión (IP); 0 = sin límite.</p>
  <form method="post" action="<?= url('opciones/antibotGuardar') ?>" class="form-grid"><?= csrf_field() ?>
    <label>CAPTCHA "No soy un robot" (Cloudflare Turnstile)
      <select name="captcha_activo">
        <option value="1" <?= (int)($cfg['captcha_activo'] ?? 0) === 1 ? 'selected' : '' ?>>Activo</option>
        <option value="0" <?= (int)($cfg['captcha_activo'] ?? 0) !== 1 ? 'selected' : '' ?>>Inactivo</option>
      </select>
    </label>
    <label>Clave pública (site key)
      <input type="text" name="site_key" maxlength="200" value="<?= $v('site_key') ?>" placeholder="0x4AAAAAAA...">
    </label>
    <label>Clave secreta
      <input type="password" name="secret" maxlength="300" autocomplete="new-password" placeholder="<?= !empty($cfg['tiene_secret']) ? 'Dejar vacío para conservar la actual' : '0x4AAAAAAA...' ?>">
    </label>
    <label>Búsquedas de celular por hora <input type="number" name="lim_buscar_hora" min="0" max="1000" value="<?= $v('lim_buscar_hora') ?>"></label>
    <label>Envíos de código por hora <input type="number" name="lim_otp_hora" min="0" max="1000" value="<?= $v('lim_otp_hora') ?>"></label>
    <label>Pacientes nuevos por día <input type="number" name="lim_paciente_dia" min="0" max="1000" value="<?= $v('lim_paciente_dia') ?>"></label>
    <label>Citas agendadas por día <input type="number" name="lim_cita_dia" min="0" max="1000" value="<?= $v('lim_cita_dia') ?>"></label>
    <label>Citas pendientes por celular con el mismo médico <input type="number" name="lim_citas_futuras" min="0" max="50" value="<?= $v('lim_citas_futuras') ?>"></label>
    <p class="ayuda col-span">Las claves se obtienen gratis en Cloudflare → Turnstile, agregando el dominio sgcopuebla.com.mx. La clave secreta se guarda cifrada.</p>
    <div class="form-actions"><button class="btn btn-primary" type="submit">Guardar</button></div>
  </form>
</div>
