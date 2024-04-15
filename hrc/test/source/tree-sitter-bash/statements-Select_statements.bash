

select choice in X Y $(ls); do
  echo $choice
  break
done

select ARG; do
  echo $ARG
  ARG=''
done
