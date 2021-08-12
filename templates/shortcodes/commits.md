{% set data = load_data(path=path) %}

{% for commit in data | split(pat="\ncommit ") -%}
    {% set lines = commit | split(pat="\n") -%}
    {% set id = lines | first | replace(from="commit ", to="") -%}
    {% set description = lines | slice(start=4, end=5) -%}
- {{ description | safe }}({{ base_url }}{{ id }})
{% endfor %}

---

```gitlog
{{ data | safe }}
```