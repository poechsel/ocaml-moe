# ocaml-moe
[WIP] Experimental ocaml wrapper around moe

Not working as of now

- Beware of `[@default ...]` in ppx\_deriving\_yojson: entries with this attribute
  will not be put in the serialized json. An issue exists about it (https://github.com/ocaml-ppx/ppx_deriving_yojson/issues/19)
- It looks like even if moe specifies that by default some values are `None`, they should be absent
  for it to work.


The pretty_view local site that comes with moe is usefull to debug the requests.
