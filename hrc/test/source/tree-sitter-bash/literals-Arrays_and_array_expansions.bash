

a=()
b=(1 2 3)

echo ${a[@]}
echo ${#b[@]}

a[$i]=50
a+=(foo "bar" $(baz))

printf "  %-9s" "${seq0:-(default)}"
