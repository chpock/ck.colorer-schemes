

if [ "$(uname)" == 'Darwin' ]; then
  echo one
fi

if [ a = -d ]; then
  echo two
fi

[[ abc == +(a|b|c) ]] && echo 1
[[ abc != +(a|b|c) ]] && echo 2
