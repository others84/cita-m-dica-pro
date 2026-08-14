<?php
/** Carga Chart.js una sola vez por pagina. */
if (empty($GLOBALS['__chartjs_loaded'])) {
    $GLOBALS['__chartjs_loaded'] = true;
    echo '<script src="' . url('assets/vendor/chartjs/chart.umd.min.js') . '"></script>';
    // Colores tomados del tema activo (variables CSS --c1..--c5)
    echo <<<'JS'
<script>
window.temaColores = function(){
  var cs = getComputedStyle(document.documentElement);
  var c = function(n, def){ var v = (cs.getPropertyValue('--c'+n)||'').trim(); return v || def; };
  return { c1:c(1,'#EAF6FF'), c2:c(2,'#BFDFFF'), c3:c(3,'#7FB6E6'), c4:c(4,'#3E7FB1'), c5:c(5,'#1E3A5F') };
};
window.temaPaleta = function(n){
  var t = window.temaColores();
  var base = [t.c5, t.c4, t.c3, t.c2, t.c1];
  var out = [];
  for (var i = 0; i < (n||10); i++) {
    var b = base[i % base.length];
    var ciclo = Math.floor(i / base.length);
    out.push(ciclo === 0 ? b : window.temaMezcla(b, ciclo % 2 ? t.c1 : t.c5, 0.25 * ciclo));
  }
  return out;
};
window.temaMezcla = function(hex, hex2, p){
  var h = function(x){ x = (x||'').replace('#',''); if (x.length===3) x = x[0]+x[0]+x[1]+x[1]+x[2]+x[2];
    return [parseInt(x.substr(0,2),16)||0, parseInt(x.substr(2,2),16)||0, parseInt(x.substr(4,2),16)||0]; };
  var a = h(hex), b = h(hex2); p = Math.min(Math.max(p||0,0),1);
  var m = a.map(function(v,i){ return Math.round(v + (b[i]-v)*p); });
  return 'rgb(' + m.join(',') + ')';
};
</script>
JS;
}
