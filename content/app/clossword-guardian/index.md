+++
title = "Piilosanaverkkoratkaisin"
+++
<style>
  body {
    max-width: initial;
  }
  #piilosana {
    margin: 1rem 0;
    overflow: auto;
  }
</style>

<div id="piilosana"></div>

<script src="clossword-guardian.FDDC2D13653FF343559A73D06AA9A007.js"></script>
<script>
{
  let search = location.search.substring(1)
  if (/^xw=[^&]+$/.test(search)) {
    let uri = decodeURIComponent(search.substring(3))
    let id = uri.split('/').pop();
    fetch(uri)
      .then(response => response.json())
      .then(xw => clossword.guardian.render_xw(
        document.getElementById("piilosana"), id, xw))
  }
}
</script>

