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
})();
</script>
</body>
</html>