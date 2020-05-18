+++
title = "Piilosanaverkkoratkaisin"
+++
<style>
  body {
    max-width: initial;
  }
  #piilosana {
    margin: 1rem 0;
  }
</style>

<div id="piilosana"></div>

<script src="clossword-guardian.3B1AE305B730B8448C8F4CAE71D41B47.js"></script>
<script>
{
  let search = location.search.substring(1)
  if (/^xw=[^&]+$/.test(search)) {
    let uri = decodeURIComponent(search.substring(3))
    fetch(uri)
      .then(response => response.json())
      .then(xw => clossword.guardian.render_xw(
        document.getElementById("piilosana"), xw))
  }
}
</script>

