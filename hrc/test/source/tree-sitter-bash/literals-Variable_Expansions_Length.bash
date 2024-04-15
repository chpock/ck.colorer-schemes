

${parameter:-1}

${parameter: -1}

${parameter:(-1)}

${matrix:$(($random%${#matrix})):1}

"${_component_to_single:${len}:2}"

"${PN::-1}"

${trarr:$(ver_cut 2):1}

${comp[@]:start:end*2-start}
