<div class="card">
  <h2 style="margin-top:0">Respaldo de Base de Datos</h2>
  <p>Para generar un respaldo, ejecute en SQL Server (con permisos del SO):</p>
  <pre style="background:#f4f7fb;padding:1rem;border-radius:6px;overflow:auto">
BACKUP DATABASE CitasMedicas
TO DISK = N'C:\Respaldos\CitasMedicas_<?= date('Ymd_His') ?>.bak'
WITH INIT, COMPRESSION, STATS = 10;</pre>
  <p>El usuario aplicativo <code>citasadmin</code> no tiene permisos de BACKUP por seguridad.</p>
</div>