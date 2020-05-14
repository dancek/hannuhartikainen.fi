+++
title = "Piilosanaverkkoratkaisin"
date = 2020-05-08T22:27:54+03:00
+++
<style>
  body {
    max-width: initial;
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

