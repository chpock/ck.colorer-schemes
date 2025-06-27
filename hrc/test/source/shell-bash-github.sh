#!/bin/bash

# https://github.com/chpock/ck.colorer-schemes/issues/6

#!/bin/bash
for i in ${arr[@]}
do
    ${command} "${i}" &
    ids+=( $! )
done

for i in ${arr[@]}
do
    ${command} "${i}" &
done

ids+=( $! )

# https://github.com/colorer/Colorer-schemes/issues/172

echo "${!var@Q}" more text here

# https://github.com/chpock/ck.colorer-schemes/issues/12

(( A + 1 ))
for i; do
    (( A + 1 ))
done

for (( i = 0; i < L; i++ )); do
    (( B = (B + A) % 65521 )) || :
done