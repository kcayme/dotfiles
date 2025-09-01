function klogs-clean
    kubectl logs $argv | sed -r "s/\x1B\[[0-9;]*[JKmsu]//g"
end
# funcsave klogs-clean
