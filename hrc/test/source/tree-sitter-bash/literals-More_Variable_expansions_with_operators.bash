

${parameter-default}
${parameter:-default}
${parameter=default}
${parameter:=default}
${parameter+alt_value}
${parameter:+alt_value}
${parameter?err_msg}
${parameter:?err_msg}
${var%Pattern}
${var%%Pattern}
${var:pos}
${var:pos:len}
${MATRIX:$(($RANDOM%${#MATRIX})):1}
${PKG_CONFIG_LIBDIR:-${ESYSROOT}/usr/$(get_libdir)/pkgconfig}
${ver_str::${#ver_str}-${#not_match}}
${value#\{sd.cicd.}
