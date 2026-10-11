<?php $controller='diasbloqueados'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0">Días bloqueados</h2>
  <p style="margin:.2rem 0 1rem;color:var(--c5)">
    Marca aquí los días en los que el médico no da consulta (vacaciones, congresos, días festivos).
    Estos días se cierran <strong>únicamente</strong> para las citas que los pacientes agendan desde la página pública.
    Médicos, asistentes y administradores pueden seguir agendando cualquier día.
    Las citas ya agendadas no se cancelan.
  </p>

  <form method="post" action="<?= url('diasbloqueados') ?>" class="form-grid"><?= csrf_field() ?>
    <label class="col-span">Médico
      <select name="medico" onchange="this.form.submit()">
        <option value="">-- selecciona --</option>
        <?php foreach ($medicos as $m): ?>
          <option value="<?= (int)$m['id_USUARIOS'] ?>" <?= (int)$idMedico === (int)$m['id_USUARIOS'] ? 'selected' : '' ?>>
            <?= htmlspecialchars((string)($m['nombre_completo'] ?? '')) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>

<?php if ($idMedico): ?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0">Bloquear días</h3>
  <form method="post" action="<?= url('diasbloqueados/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id_MEDICO" value="<?= (int)$idMedico ?>">
    <label>Fecha
      <input type="date" name="fecha_desde" required>
    </label>
    <label>Hasta (opcional)
      <input type="date" name="fecha_hasta">
    </label>
    <label class="col-span">Motivo (opcional)
      <input type="text" name="motivo" maxlength="200" placeholder="Vacaciones, congreso, día festivo...">
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn">Bloquear</button>
    </div>
  </form>
</div>

<div class="table-responsive">
  <table class="data">
    <thead><tr><th>Fecha</th><th>Motivo</th><th>Acciones</th></tr></thead>
    <tbody>
      <?php if (empty($dias)): ?>
        <tr><td colspan="3" style="text-align:center;color:var(--c4);padding:1rem">Sin días bloqueados</td></tr>
      <?php else: foreach ($dias as $d): ?>
        <?php $f = $d['fecha'] ?? ''; if ($f instanceof DateTime) $f = $f->format('Y-m-d'); ?>
        <tr>
          <td><?= htmlspecialchars(substr((string)$f, 0, 10)) ?></td>
          <td><?= htmlspecialchars((string)($d['motivo'] ?? '')) ?></td>
          <td class="acts">
            <form method="post" action="<?= url('diasbloqueados/eliminar') ?>"
                  onsubmit="return confirm('¿Liberar el día <?= htmlspecialchars(substr((string)$f, 0, 10)) ?>?');">
              <?= csrf_field() ?>
              <input type="hidden" name="id_DIA" value="<?= (int)$d['id_DIA_BLOQUEADO_MEDICO'] ?>">
              <input type="hidden" name="id_MEDICO" value="<?= (int)$idMedico ?>">
              <button class="btn btn-sec">Liberar</button>
            </form>
          </td>
        </tr>
      <?php endforeach; endif; ?>
    </tbody>
  </table>
</div>
<?php else: ?>
  <p style="color:var(--c5)">Selecciona un médico para ver y definir sus días bloqueados.</p>
<?php endif; ?>

