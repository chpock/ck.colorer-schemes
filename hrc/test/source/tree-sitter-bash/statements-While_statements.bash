

while something happens; do
  echo a
  echo b
done

while local name="$1" val="$2"; shift 2; do
  printf "%s (%s)\n" "$val" "$name"
done
