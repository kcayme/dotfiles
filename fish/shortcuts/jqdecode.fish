function jqdecode --description 'Decode the double-encoded line field of a Grafana/Loki log export'
  set -l filter 'map(.line |= (fromjson? // .))'
  if test (count $argv) -eq 0
    if isatty stdin
      echo "usage: jqdecode <export.json>  or  ... | jqdecode" >&2
      return 1
    end
    jq $filter
    return
  end
  if test (count $argv) -ne 1
    echo "usage: jqdecode <export.json>  or  ... | jqdecode" >&2
    return 1
  end
  if not test -f $argv[1]
    echo "jqdecode: no such file: $argv[1]" >&2
    return 1
  end
  set -l out (string replace -r '\.json$' '' -- $argv[1]).decoded.json
  jq $filter $argv[1] > $out; or return
  realpath $out
end
