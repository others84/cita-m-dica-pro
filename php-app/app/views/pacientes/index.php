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
<?php if (($rol ?? '') === 'admin_sistema'): ?>
<div class="card" style="margin-bottom:1rem">
  <h3 style="margin-top:0;color:var(--c5)">Filtro</h3>
  <form method="get" action="<?= url('pacientes') ?>" class="form-grid">
    <label>Clinica
      <select name="f_clinica" onchange="this.form.submit()">
        <option value="">-- todas --</option>
        <?php foreach ($clinicas as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= (int)($fClinica ?? 0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
  </form>
</div>
<?php endif; ?>
<div class="card" style="margin-bottom:1rem">
  <h2 style="margin-top:0;color:var(--c5)"><?= $editId ? 'Modificar paciente #' . (int)$editId : 'Nuevo paciente' ?></h2>
  <form method="post" action="<?= url('pacientes/guardar') ?>" class="form-grid">
    <input type="hidden" name="id" value="<?= htmlspecialchars((string)($editId ?? '')) ?>">
    <label>Clinica
      <select name="id_CLINICA" required>
        <option value="">-- seleccione --</option>
        <?php foreach ($clinicas as $cl): ?>
          <option value="<?= (int)$cl['id_CLINICA'] ?>" <?= isset($editRow)&&(int)($editRow['id_CLINICA']??0)===(int)$cl['id_CLINICA']?'selected':'' ?>>
            <?= htmlspecialchars($cl['nombre']) ?>
          </option>
        <?php endforeach; ?>
      </select>
    </label>
    <label>Apellido paterno <input name="ap_paterno" required value="<?= htmlspecialchars($editRow['ap_paterno'] ?? '') ?>"></label>
    <label>Apellido materno <input name="ap_materno" value="<?= htmlspecialchars($editRow['ap_materno'] ?? '') ?>"></label>
    <label>Nombre(s) <input name="nombre" required value="<?= htmlspecialchars($editRow['nombre'] ?? '') ?>"></label>
    <label>Direccion <input name="direccion" value="<?= htmlspecialchars($editRow['direccion'] ?? '') ?>"></label>
    <label>Telefono <input name="telefono" value="<?= htmlspecialchars($editRow['telefono'] ?? '') ?>"></label>
    <label>Email <input type="email" name="email" value="<?= htmlspecialchars($editRow['email'] ?? '') ?>"></label>
    <label>Fecha nacimiento <input type="date" name="fecha_nacimiento" value="<?= htmlspecialchars($fn) ?>"></label>
    <label>Genero
      <select name="id_CATALOGO_GENERO">
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
    <div class="form-actions" style="grid-column:1/-1">
      <button class="btn" type="submit"><?= $editId ? 'Actualizar' : 'Guardar' ?></button>
      <?php if ($editId): ?><a class="btn btn-sec" href="<?= url('pacientes') ?>">Cancelar</a><?php endif; ?>
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

<table class="data">
  <thead><tr><th>Nombre</th><th>Telefono</th><th>Email</th><th>Municipio</th><th>Acciones</th></tr></thead>
  <tbody>
    <?php if (empty($rows)): ?>
      <tr><td colspan="5" style="text-align:center;padding:1rem;color:var(--c4)">Sin pacientes</td></tr>
    <?php else: foreach ($rows as $p):
      $nom = trim(($p['ap_paterno']??'').' '.($p['ap_materno']??'').' '.($p['nombre']??'')); ?>
      <tr>
        <td><?= htmlspecialchars($nom) ?></td>
        <td><?= htmlspecialchars($p['telefono'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['email'] ?? '') ?></td>
        <td><?= htmlspecialchars($p['municipio'] ?? '') ?></td>
        <td class="acts">
          <a class="btn btn-sec" href="<?= url('pacientes?edit=' . (int)$p['id_PACIENTE']) ?>">Editar</a>
          <form method="post" action="<?= url('pacientes/eliminar') ?>" style="display:inline" onsubmit="return confirm('Eliminar paciente?')">
            <input type="hidden" name="id" value="<?= (int)$p['id_PACIENTE'] ?>">
            <button class="btn btn-danger" type="submit">Eliminar</button>
          </form>
        </td>
      </tr>
    <?php endforeach; endif; ?>
  </tbody>
</table>