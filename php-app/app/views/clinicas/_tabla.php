<?php
  $ord = $ord ?? 'nombre';
  $dir = $dir ?? 'asc';
  $colIndex = ['nombre'=>1,'pais'=>2,'estado'=>3];
  $th = function (string $col, string $label) use ($ord, $dir) {
      $flecha = $ord === $col ? ($dir === 'asc' ? ' ▲' : ' ▼') : '';
      $cls = $ord === $col ? ' class="col-ordenada"' : '';
      echo '<th'.$cls.'>';
      echo '<form method="post" action="' . url('clinicas/ordenar') . '" class="sort-form" style="display:inline;margin:0;padding:0">';
      echo csrf_field();
      echo '<input type="hidden" name="ord" value="' . htmlspecialchars($col) . '">';
      echo '<button type="submit" class="sort-btn">' . htmlspecialchars($label) . $flecha . '</button>';
      echo '</form>';
      echo '</th>';
  };
  $ordClass = isset($colIndex[$ord]) ? ' ord-col-'.$colIndex[$ord] : '';
?>
<div class="table-responsive">
<table class="data tabla-clinicas<?= $ordClass ?>">
  <thead><tr><?php $th('nombre','Nombre'); ?><?php $th('pais','Pais'); ?><?php $th('estado','Estado'); ?><th>Municipio</th><th>Telefono</th><th>Esquema</th><th>Asistentes</th><th>Medicos</th><th>Admins</th><th>Activa</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="11" style="text-align:center;padding:1rem;color:var(--c4)">Sin clinicas</td></tr>
    <?php else: foreach ($rows as $c): ?>
      <tr>
        <td><?= htmlspecialchars($c['nombre']) ?></td>
        <td><?= htmlspecialchars($c['pais'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['estado'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['municipio'] ?? '') ?></td>
        <td><?= htmlspecialchars($c['telefono'] ?? '') ?></td>
        <td><?= htmlspecialchars($esquemas[$c['esquema'] ?? '']['label'] ?? ($c['esquema'] ?? '')) ?></td>
        <td><?= (int)($c['usuarios_asistentes'] ?? 0) ?>/<?= (int)($c['max_asistentes'] ?? 0) ?></td>
        <td><?= (int)($c['usuarios_medicos'] ?? 0) ?>/<?= (int)($c['max_medicos'] ?? 0) ?></td>
        <td><?= (int)($c['usuarios_admins'] ?? 0) ?>/<?= (int)($c['max_admins'] ?? 0) ?></td>
        <td><span class="badge <?= empty($c['activo'])?'off':'' ?>"><?= empty($c['activo']) ? 'No' : 'Si' ?></span></td>
        <td class="acts">
          <?php post_button('clinicas', ['edit' => (int)$c['id_CLINICA']], 'Editar', 'btn btn-sec'); ?>
          <?php post_button('contratos/clinica', ['id' => (int)$c['id_CLINICA']], 'Contrato y aviso', 'btn btn-sec'); ?>
          <?php if (!empty($c['activo'])): ?>
            <?php post_button('clinicas/desactivar', ['id' => (int)$c['id_CLINICA']], 'Desactivar', 'btn btn-danger', 'Desactivar clinica?'); ?>
          <?php else: ?>
            <?php post_button('clinicas/activar', ['id' => (int)$c['id_CLINICA']], 'Activar', 'btn'); ?>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>
</div>

<?php $paginas = (int)($paginas ?? 1); $pag = (int)($pag ?? 1); ?>
<?php if (($totalClinicas ?? 0) > 0): ?>
<div class="pager" style="display:flex;align-items:center;gap:.4rem;flex-wrap:wrap;margin-top:.75rem">
  <span style="color:var(--c4)">
    Pagina <?= $pag ?> de <?= $paginas ?> · <?= (int)$totalClinicas ?> clinicas
  </span>
  <?php if ($pag > 1): ?>
    <form method="post" action="<?= url('clinicas/pagina') ?>" class="page-form" style="display:inline;margin:0;padding:0">
      <?= csrf_field() ?><input type="hidden" name="pag" value="1"><button type="submit" class="btn btn-sec page-btn">«</button>
    </form>
    <form method="post" action="<?= url('clinicas/pagina') ?>" class="page-form" style="display:inline;margin:0;padding:0">
      <?= csrf_field() ?><input type="hidden" name="pag" value="<?= $pag - 1 ?>"><button type="submit" class="btn btn-sec page-btn">‹</button>
    </form>
  <?php endif; ?>
  <?php
    $ini = max(1, $pag - 2); $fin = min($paginas, $ini + 4); $ini = max(1, $fin - 4);
    for ($i = $ini; $i <= $fin; $i++) {
        echo '<form method="post" action="' . url('clinicas/pagina') . '" class="page-form" style="display:inline;margin:0;padding:0">';
        echo csrf_field();
        echo '<input type="hidden" name="pag" value="' . $i . '">';
        echo '<button type="submit" class="' . ($i === $pag ? 'btn' : 'btn btn-sec') . ' page-btn">' . $i . '</button>';
        echo '</form>';
    }
  ?>
  <?php if ($pag < $paginas): ?>
    <form method="post" action="<?= url('clinicas/pagina') ?>" class="page-form" style="display:inline;margin:0;padding:0">
      <?= csrf_field() ?><input type="hidden" name="pag" value="<?= $pag + 1 ?>"><button type="submit" class="btn btn-sec page-btn">›</button>
    </form>
    <form method="post" action="<?= url('clinicas/pagina') ?>" class="page-form" style="display:inline;margin:0;padding:0">
      <?= csrf_field() ?><input type="hidden" name="pag" value="<?= $paginas ?>"><button type="submit" class="btn btn-sec page-btn">»</button>
    </form>
  <?php endif; ?>
</div>
<?php endif; ?>
