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

<script src="clossword-guardian.1C474B877D44F2CED466619E39225E70.js"></script>
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

