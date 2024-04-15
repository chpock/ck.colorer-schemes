

(
  ./start-server --port=80
) &

time ( cd tests && sh run-tests.sh )
