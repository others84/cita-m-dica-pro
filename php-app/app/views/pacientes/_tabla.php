<?php
  $ord = $ord ?? 'nombre';
  $dir = $dir ?? 'asc';
  $colIndex = ['nombre'=>1,'fecha_nacimiento'=>5,'pais'=>7];
  $th = function (string $col, string $label) use ($ord, $dir) {
      $flecha = $ord === $col ? ($dir === 'asc' ? ' ▲' : ' ▼') : '';
      $cls = $ord === $col ? ' class="col-ordenada"' : '';
      echo '<th'.$cls.'>';
      echo '<button type="button" class="sort-btn" data-ord="'.htmlspecialchars($col).'">' . htmlspecialchars($label) . $flecha . '</button>';
      echo '</th>';
  };
  $ordClass = isset($colIndex[$ord]) ? ' ord-col-'.$colIndex[$ord] : '';
?>
<div class="table-responsive">
<table class="data tabla-pacientes<?= $ordClass ?>">
  <thead><tr><?php $th('nombre','Nombre completo'); ?><th>Direccion</th><th>Telefono</th><th>Email</th><?php $th('fecha_nacimiento','Fecha nacimiento'); ?><th>Genero</th><?php $th('pais','Pais'); ?><th>Estado</th><th>Municipio</th><th>Observaciones</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="11" style="text-align:center;padding:1rem;color:var(--c4)">Sin pacientes</td></tr>
    <?php else: foreach ($rows as $p):
      $fn = $p['fecha_nacimiento'] ?? '';
      if ($fn instanceof DateTime) $fn = $fn->format('Y-m-d');
      $fn = $fn ? substr((string)$fn,0,10) : '';
      $nom = trim(($p['ap_paterno']??'').' '.($p['ap_materno']??'').' '.($p['nombre']??''));
      $obs = trim((string)($p['observaciones'] ?? ''));
      $obsCorta = mb_strlen($obs) > 40 ? mb_substr($obs, 0, 40) . '...' : $obs;
    ?>
      <tr>
        <td><?= htmlspecialchars($nom) ?></td>
        <td><?= htmlspecialchars($p['direccion'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['telefono'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['email'] ?? '') ?></td>
        <td><?= htmlspecialchars($fn) ?></td>
        <td><?= htmlspecialchars($p['genero'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['pais'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['estado'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['municipio'] ?? '') ?></td>
        <td title="<?= htmlspecialchars($obs) ?>"><?= htmlspecialchars($obsCorta) ?></td>
        <td class="acts">
          <?php post_button('pacientes', ['edit' => (int)$p['id_PACIENTE']], 'Editar', 'btn btn-sec'); ?>
          <?php post_button('pacientes/eliminar', ['id' => (int)$p['id_PACIENTE']], 'Eliminar', 'btn btn-danger', 'Eliminar paciente?'); ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>
</div>

<?php $paginas = (int)($paginas ?? 1); $pag = (int)($pag ?? 1); ?>
<?php if (($totalPacientes ?? 0) > 0): ?>
<div class="pager" style="display:flex;align-items:center;gap:.4rem;flex-wrap:wrap;margin-top:.75rem">
  <span style="color:var(--c4)">
    Pagina <?= $pag ?> de <?= $paginas ?> · <?= (int)$totalPacientes ?> pacientes
  </span>
  <?php if ($pag > 1): ?>
    <button type="button" class="btn btn-sec page-btn" data-pag="1">«</button>
    <button type="button" class="btn btn-sec page-btn" data-pag="<?= $pag - 1 ?>">‹</button>
  <?php endif; ?>
  <?php
    $ini = max(1, $pag - 2); $fin = min($paginas, $ini + 4); $ini = max(1, $fin - 4);
    for ($i = $ini; $i <= $fin; $i++) {
        echo '<button type="button" class="'.($i === $pag ? 'btn' : 'btn btn-sec').' page-btn" data-pag="'.$i.'">'.$i.'</button>';
    }
  ?>
  <?php if ($pag < $paginas): ?>
    <button type="button" class="btn btn-sec page-btn" data-pag="<?= $pag + 1 ?>">›</button>
    <button type="button" class="btn btn-sec page-btn" data-pag="<?= $paginas ?>">»</button>
  <?php endif; ?>
</div>
<?php endif; ?>
