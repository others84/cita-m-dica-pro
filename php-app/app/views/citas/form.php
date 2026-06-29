<?php
$f  = $editRow['fecha_cita']  ?? '';
$hi = $editRow['hora_inicio'] ?? '';
$hf = $editRow['hora_fin']    ?? '';
if ($f  instanceof DateTime) $f  = $f->format('Y-m-d');
if ($hi instanceof DateTime) $hi = $hi->format('H:i');
if ($hf instanceof DateTime) $hf = $hf->format('H:i');
$f  = $f  ? substr((string)$f,0,10)  : '';
$hi = $hi ? substr((string)$hi,0,5) : '';
$hf = $hf ? substr((string)$hf,0,5) : '';
?>
<div class="card">
  <h2 style="margin-top:0;color:var(--c5)"><?= $editId ? 'Modificar cita #' . (int)$editId : 'Nueva cita' ?></h2>
  <form method="post" action="<?= url('citas/guardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">

    <label>Paciente
      <select name="id_PACIENTE" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($pacientes as $p):
          $nom = trim(($p['ap_paterno']??'') . ' ' . ($p['ap_materno']??'') . ' ' . ($p['nombre']??'')); ?>
          <option value="<?= (int)$p['id_PACIENTE'] ?>" <?= isset($editRow) && (int)($editRow['id_PACIENTE']??0)===(int)$p['id_PACIENTE'] ? 'selected':'' ?>>
            <?= htmlspecialchars($nom) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Medico
      <select name="id_MEDICO" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($medicos as $m): ?>
          <option value="<?= (int)$m['id_MEDICO'] ?>" <?= isset($editRow) && (int)($editRow['id_MEDICO']??0)===(int)$m['id_MEDICO'] ? 'selected':'' ?>>
            <?= htmlspecialchars($m['nombre_completo']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Consultorio
      <select name="id_CONSULTORIO" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($consultorios as $co): ?>
          <option value="<?= (int)$co['id_CONSULTORIO'] ?>" <?= isset($editRow) && (int)($editRow['id_CONSULTORIO']??0)===(int)$co['id_CONSULTORIO'] ? 'selected':'' ?>>
            <?= htmlspecialchars($co['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Especialidad
      <select name="id_CATALOGO_ESPECIALIDAD" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($especialidades as $e): ?>
          <option value="<?= (int)$e['id_CATALOGO_ESPECIALIDAD'] ?>" <?= isset($editRow) && (int)($editRow['id_CATALOGO_ESPECIALIDAD']??0)===(int)$e['id_CATALOGO_ESPECIALIDAD'] ? 'selected':'' ?>>
            <?= htmlspecialchars($e['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Fecha
      <input type="date" name="fecha_cita" required value="<?= htmlspecialchars($f) ?>">
    </label>
    <label>Hora inicio
      <input type="time" name="hora_inicio" required value="<?= htmlspecialchars($hi) ?>">
    </label>
    <label>Hora fin
      <input type="time" name="hora_fin" required value="<?= htmlspecialchars($hf) ?>">
    </label>

    <label>Estado
      <select name="id_CATALOGO_ESTADO_CITAS" required>
        <?php foreach ($estados as $es): ?>
          <option value="<?= (int)$es['id_CATALOGO_ESTADO_CITAS'] ?>"
            <?= isset($editRow) && (int)($editRow['id_CATALOGO_ESTADO_CITAS']??0)===(int)$es['id_CATALOGO_ESTADO_CITAS'] ? 'selected':'' ?>>
            <?= htmlspecialchars($es['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>

    <label>Precio
      <input type="number" name="precio" step="0.01" min="0" value="<?= htmlspecialchars((string)($editRow['precio'] ?? '0.00')) ?>">
    </label>

    <label>Email notificacion
      <input type="email" name="email_notif" value="<?= htmlspecialchars($editRow['email_notif'] ?? '') ?>">
    </label>
    <label>Celular notificacion (WA)
      <input type="text" name="celular_notif" value="<?= htmlspecialchars($editRow['celular_notif'] ?? '') ?>">
    </label>
    <label>Horas anticipacion
      <input type="number" name="horas_anticipacion_notif" min="0" max="240" value="<?= htmlspecialchars((string)($editRow['horas_anticipacion_notif'] ?? 24)) ?>">
    </label>

    <label style="flex-direction:row;align-items:center;gap:.5rem">
      <input type="checkbox" name="notifica_email" value="1" <?= !empty($editRow['notifica_email']) ? 'checked':'' ?>>
      Notificar por email
    </label>
    <label style="flex-direction:row;align-items:center;gap:.5rem">
      <input type="checkbox" name="notifica_wa" value="1" <?= !empty($editRow['notifica_wa']) ? 'checked':'' ?>>
      Notificar por WhatsApp
    </label>

    <label style="grid-column:1/-1">Observaciones
      <textarea name="observaciones" rows="3"><?= htmlspecialchars($editRow['observaciones'] ?? '') ?></textarea>
    </label>

    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit"><?= $editId ? 'Actualizar' : 'Agendar' ?></button>
      <a class="btn btn-sec" href="<?= url('citas') ?>">Cancelar</a>
    </div>
  </form>
</div>