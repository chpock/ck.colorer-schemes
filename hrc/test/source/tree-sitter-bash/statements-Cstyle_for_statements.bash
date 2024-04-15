

for (( c=1; c<=5; c++ ))
do
  echo $c
done

for (( c=1; c<=5; c++ )) {
	echo $c
}

for (( ; ; ))
do
  echo 'forever'
done

for ((cx = 0; c = $cx / $pf, c < $wc - $k; )); do
		echo "$cx"
done

for (( i = 4;;i--)) ; do echo $i; if (( $i == 0 )); then break; fi; done

# added post-bash-4.2
for (( i = j = k = 1; i % 9 || (j *= -1, $( ((i%9)) || printf " " >&2; echo 0), k++ <= 10); i += j ))
do
printf "$i"
done

echo

( for (( i = j = k = 1; i % 9 || (j *= -1, $( ((i%9)) || printf " " >&2; echo 0), k++ <= 10); i += j ))
do
printf "$i"
done )
