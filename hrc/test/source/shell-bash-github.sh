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
