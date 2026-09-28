    </section>
  </main>
</div>
<script>
(function(){
  var groups = document.querySelectorAll('aside.sidebar details.menu-group');
  groups.forEach(function(d, i){
    var label = (d.querySelector('summary')?.textContent || ('g'+i)).trim();
    var key = 'sb:' + label;
    if (localStorage.getItem(key) === '1') d.setAttribute('open','');
    d.addEventListener('toggle', function(){
      localStorage.setItem(key, d.open ? '1' : '0');
    });
  });

  var body = document.body;
  var toggle = document.querySelector('.menu-toggle');
  var close = document.querySelector('.sidebar-close');
  var backdrop = document.querySelector('.sidebar-backdrop');
  function setMenu(open){
    body.classList.toggle('menu-open', open);
    if (toggle) toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
  }
  if (toggle) toggle.addEventListener('click', function(){ setMenu(!body.classList.contains('menu-open')); });
  if (close) close.addEventListener('click', function(){ setMenu(false); });
  if (backdrop) backdrop.addEventListener('click', function(){ setMenu(false); });
  document.addEventListener('keydown', function(e){ if (e.key === 'Escape') setMenu(false); });
  window.addEventListener('resize', function(){ if (window.innerWidth > 900) setMenu(false); });
})();
</script>
</body>
</html>