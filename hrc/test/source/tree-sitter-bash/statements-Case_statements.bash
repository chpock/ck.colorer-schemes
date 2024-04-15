

case "opt" in
  a)
    echo a
    ;;

  b)
    echo b
    ;&

  c)
    echo c;;
esac

case "opt" in
  (a)
    echo a
    ;;

  (b)
    echo b
    ;&

  (c)
    echo c;;
esac

case "$Z" in
  ab*|cd*) ef
esac

case $dest in
  *.[1357])
    exit $?
    ;;
esac

case x in x) echo meow ;; esac

case foo in
  bar\ baz) : ;;
esac

case "$arg" in
  *([0-9])([0-9])) echo "$arg"
esac

case ${lang} in
CMakeLists.txt | \
	cmake_modules | \
	${PN}.pot) ;;
*) rm -r ${lang} || die ;;
esac
