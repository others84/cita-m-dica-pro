<?php
$fn = $editRow['fecha_nacimiento'] ?? '';
if ($fn instanceof DateTime) $fn = $fn->format('Y-m-d');
$fn = $fn ? substr((string)$fn,0,10) : '';
// Mapeos para el cascada Pais -> Estado -> Municipio
$paisPorEstado = [];
foreach ($estados as $e) {
  $paisPorEstado[(int)$e['id_CATALOGO_ESTADOS']] = (int)($e['id_CATALOGO_PAIS'] ?? 0);
}
$estadoPorMun = [];
foreach ($municipios as $mu) {
  $estadoPorMun[(int)$mu['id_CATALOGO_MUNICIPIO']] = (int)($mu['id_CATALOGO_ESTADOS'] ?? 0);
}
$selMun    = isset($editRow) ? (int)($editRow['id_CATALOGO_MUNICIPIO'] ?? 0) : 0;
$selEstado = $selMun ? ($estadoPorMun[$selMun] ?? 0) : 0;
$selPais   = $selEstado ? ($paisPorEstado[$selEstado] ?? 0) : 0;
?>
<?php $controller='pacientes'; include __DIR__.'/../_partials/filtro_clinica.php'; ?>
<?php if (class_exists('Database')) {
  Database::log(sprintf(
    'PACIENTES.view rol=%s user=%s fClinica=%s hiddenClinicaNuevo=%s post_f_clinica=%s session_f_clinica=%s',
    $rol ?? '?',
    $_SESSION['user']['usuario'] ?? '?',
    $fClinica ?? 'NULL',
    (int)($editRow['id_CLINICA'] ?? $fClinica ?? 0),
    $_POST['f_clinica'] ?? 'NO_POST',
    $_SESSION['f_clinica'] ?? 'NULL'
  ));
} ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0;color:var(--c5)"><?= $editId ? 'Modificar paciente' : 'Nuevo paciente' ?></h2>
  <form method="post" action="<?= url('pacientes/guardar') ?>" class="form-grid"><?= csrf_field() ?>
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <?php $clinicaForm = (int)($editRow['id_CLINICA'] ?? $fClinica ?? 0); ?>
    <input type="hidden" name="id_CLINICA" value="<?= $clinicaForm ?>">
    <?php if ($clinicaForm <= 0): ?>
      <p style="grid-column:1/-1;color:#b00">Selecciona una clinica en el apartado "Filtro" para poder registrar pacientes.</p>
    <?php endif; ?>
    <label>Apellido paterno <input name="ap_paterno" required value="<?= htmlspecialchars($editRow['ap_paterno'] ?? '') ?>"></label>
    <label>Apellido materno <input name="ap_materno" required value="<?= htmlspecialchars($editRow['ap_materno'] ?? '') ?>"></label>
    <label>Nombre(s) <input name="nombre" required value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>"></label>
    <label>Direccion <input name="direccion" required value="<?= htmlspecialchars($editRow['direccion'] ?? '') ?>"></label>
    <label>Telefono <input name="telefono" required value="<?= htmlspecialchars($editRow['telefono'] ?? '') ?>"></label>
    <label>Email <input type="email" name="email" required value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>Fecha nacimiento <input type="date" name="fecha_nacimiento" required value="<?= htmlspecialchars($fn) ?>"></label>
    <label>Genero
      <select name="id_CATALOGO_GENERO" required>
        <option value="">--</option>
        <?php foreach ($generos as $g): ?>
          <option value="<?= (int)$g['id_CATALOGO_GENERO'] ?>" <?= isset($editRow)&&(int)($editRow['id_CATALOGO_GENERO']??0)===(int)$g['id_CATALOGO_GENERO']?'selected':'' ?>>
            <?= htmlspecialchars($g['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Pais
      <select id="sel_pais" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($paises as $p): ?>
          <option value="<?= (int)$p['id_CATALOGO_PAIS'] ?>" <?= $selPais===(int)$p['id_CATALOGO_PAIS']?'selected':'' ?>>
            <?= htmlspecialchars($p['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Estado
      <select id="sel_estado" required>
        <option value="">-- seleccione --</option>
      </select>
    </label>
    <label>Municipio
      <select id="sel_municipio" name="id_CATALOGO_MUNICIPIO" required>
        <option value="">-- seleccione --</option>
      </select>
    </label>
    <label style="grid-column:1/-1">Observaciones
      <textarea name="observaciones" rows="3" maxlength="500"><?= htmlspecialchars((string)($editRow['observaciones'] ?? '')) ?></textarea>
    </label>
    <label class="chk">
      <input type="checkbox" name="notifica_email" value="1" <?= !empty($editRow['notifica_email']) ? 'checked' : '' ?>>
      Enviar notificación por correo
    </label>
    <label class="chk">
      <input type="checkbox" name="notifica_wa" value="1" <?= !empty($editRow['notifica_wa']) ? 'checked' : '' ?>>
      Enviar notificación por WhatsApp
    </label>
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit" <?= $clinicaForm <= 0 ? 'disabled' : '' ?>><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><button class="btn btn-sec" type="submit" formnovalidate name="edit" value="" formaction="<?= url('pacientes') ?>">Cancelar</button><?php  endif; ?>
    </div>
  </form>
</div>

<script>
(function(){
  var ESTADOS = <?= json_encode(array_map(function($e){
    return ['id'=>(int)$e['id_CATALOGO_ESTADOS'],'nombre'=>$e['nombre'],'pais'=>(int)($e['id_CATALOGO_PAIS']??0)];
  }, $estados)) ?>;
  var MUNIS = <?= json_encode(array_map(function($m){
    return ['id'=>(int)$m['id_CATALOGO_MUNICIPIO'],'nombre'=>$m['nombre'],'estado'=>(int)($m['id_CATALOGO_ESTADOS']??0)];
  }, $municipios)) ?>;
  var selPais = <?= (int)$selPais ?>, selEstado = <?= (int)$selEstado ?>, selMun = <?= (int)$selMun ?>;
  var pa = document.getElementById('sel_pais'),
      es = document.getElementById('sel_estado'),
      mu = document.getElementById('sel_municipio');
  function fillEstados(){
    var pid = parseInt(pa.value||0,10);
    es.innerHTML = '<option value="">-- seleccione --</option>';
    ESTADOS.filter(function(e){return e.pais===pid;}).forEach(function(e){
      var o = new Option(e.nombre, e.id);
      if (e.id===selEstado) o.selected = true;
      es.appendChild(o);
    });
    fillMunis();
  }
  function fillMunis(){
    var eid = parseInt(es.value||0,10);
    mu.innerHTML = '<option value="">-- seleccione --</option>';
    MUNIS.filter(function(m){return m.estado===eid;}).forEach(function(m){
      var o = new Option(m.nombre, m.id);
      if (m.id===selMun) o.selected = true;
      mu.appendChild(o);
    });
  }
  pa.addEventListener('change', function(){ selEstado=0; selMun=0; fillEstados(); });
  es.addEventListener('change', function(){ selMun=0; fillMunis(); });
  if (selPais) fillEstados(); // pre-carga en modo edicion
})();
</script>

<div class="table-responsive">
<table class="data tabla-pacientes">
  <thead><tr><th>Nombre completo</th><th>Direccion</th><th>Telefono</th><th>Email</th><th>Fecha nacimiento</th><th>Genero</th><th>Pais</th><th>Estado</th><th>Municipio</th><th>Observaciones</th><th>Acciones</th></tr></thead>
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
    <?php post_button('pacientes/pagina', ['pag' => 1], '«', 'btn btn-sec'); ?>
    <?php post_button('pacientes/pagina', ['pag' => $pag - 1], '‹', 'btn btn-sec'); ?>
  <?php endif; ?>
  <?php
    $ini = max(1, $pag - 2); $fin = min($paginas, $ini + 4); $ini = max(1, $fin - 4);
    for ($i = $ini; $i <= $fin; $i++) {
        post_button('pacientes/pagina', ['pag' => $i], (string)$i, $i === $pag ? 'btn' : 'btn btn-sec');
    }
  ?>
  <?php if ($pag < $paginas): ?>
    <?php post_button('pacientes/pagina', ['pag' => $pag + 1], '›', 'btn btn-sec'); ?>
    <?php post_button('pacientes/pagina', ['pag' => $paginas], '»', 'btn btn-sec'); ?>
  <?php endif; ?>
</div>
<?php endif; ?>