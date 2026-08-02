<?php
/** Carga Chart.js una sola vez por pagina. */
if (empty($GLOBALS['__chartjs_loaded'])) {
    $GLOBALS['__chartjs_loaded'] = true;
    echo '<script src="' . url('assets/vendor/chartjs/chart.umd.min.js') . '"></script>';
}
