<?php $controller='horarios'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php
$h = $editRow['horario'] ?? null;
$hv = fn($k) => htmlspecialchars((string)($h[$k] ?? ''));
?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0">Horario de atención</h2>
  <p style="margin:.2rem 0 1rem;color:var(--c5)">
    Estos horarios limitan <strong>únicamente</strong> las citas que los pacientes agendan desde la página pública.
    Los médicos, asistentes y administradores pueden seguir agendando en cualquier horario.
    La página pública solo permite agendar de lunes a viernes.
  </p>

  <?php if ($editRow): ?>
    <form method="post" action="<?= url('horarios/guardar') ?>" class="form-grid"><?= csrf_field() ?>
      <input type="hidden" name="id_MEDICO" value="<?= (int)$editRow['id_USUARIOS'] ?>">
      <label class="col-span">Médico
        <input type="text" value="<?= htmlspecialchars((string)$editRow['nombre_completo']) ?>" readonly>
      </label>
      <label>Hora de inicio de consultas
        <input type="time" name="hora_inicio" step="900" required value="<?= $hv('hora_inicio') ?>">
      </label>
      <label>Hora de término de consultas
        <input type="time" name="hora_fin" step="900" required value="<?= $hv('hora_fin') ?>">
      </label>
      <label>Comida - inicio
        <input type="time" name="comida_inicio" step="900" value="<?= $hv('comida_inicio') ?>">
      </label>
      <label>Comida - fin
        <input type="time" name="comida_fin" step="900" value="<?= $hv('comida_fin') ?>">
      </label>
      <div class="form-actions" style="grid-column:1/-1">
        <button class="btn">Guardar horario</button>
        <?php post_button('horarios', ['edit' => ''], 'Cancelar', 'btn btn-sec'); ?>
      </div>
    </form>
  <?php else: ?>
    <p style="margin:0;color:var(--c5)">Selecciona un médico de la tabla para definir su horario.</p>
  <?php endif; ?>
</div>

<div class="table-responsive">
  <table class="data">
    <thead><tr><th>Médico</th><th>Clínica</th><th>Inicio</th><th>Comida</th><th>Término</th><th>Acciones</th></tr></thead>
    <tbody>
      <?php if (empty($rows)): ?>
        <tr><td colspan="6" style="text-align:center;color:var(--c4);padding:1rem">Sin médicos</td></tr>
      <?php else: foreach ($rows as $r): $ho = $r['horario']; ?>
        <tr>
          <td><?= htmlspecialchars((string)$r['nombre_completo']) ?></td>
          <td><?= htmlspecialchars((string)$r['clinica']) ?></td>
          <td><?= htmlspecialchars((string)$ho['hora_inicio']) ?></td>
          <td>
            <?php if (!empty($ho['comida_inicio']) && !empty($ho['comida_fin'])): ?>
              <?= htmlspecialchars($ho['comida_inicio'] . ' - ' . $ho['comida_fin']) ?>
            <?php else: ?>
              <span style="color:var(--c5)">Sin definir</span>
            <?php endif; ?>
          </td>
          <td><?= htmlspecialchars((string)$ho['hora_fin']) ?></td>
          <td class="acts">
            <?php post_button('horarios', ['edit' => (int)$r['id_USUARIOS']], !empty($ho['default']) ? 'Definir' : 'Editar', 'btn btn-sec'); ?>
          </td>
        </tr>
      <?php endforeach; endif; ?>
    </tbody>
  </table>
</div>
