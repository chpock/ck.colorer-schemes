https://github.com/golang/go/blob/6c3b5a2798c83d583cb37dba9f39c47300d19f1f/src/text/template/parse/parse_test.go#L28

{{ 0 }}
{{ -0 }}
{{ 73 }}
{{ 7_3 }}
{{ 0b10_010_01 }}
{{ 0B10_010_01 }}
{{ 073 }}
{{ 0o73 }}
{{ 0O73 }}
{{ 0x73 }}
{{ 0X73 }}
{{ 0x7_3 }}
{{ -73 }}
{{ +73 }}
{{ 100 }}
{{ 1e9 }}
{{ -1e9 }}
{{ -1.2 }}
{{ 1e19 }}
{{ 1e1_9 }}
{{ 1E19 }}
{{ -1e19 }}
{{ 0x_1p4 }}
{{ 0X_1P4 }}
{{ 0x_1p-4 }}
{{ 4i }}
{{ -1.2+4.2i }}  -1.2 + 4.2i
{{ 073i }} not octal! complex with 0 imaginary are float (and maybe integer)
{{ 0i }}
{{ -1.2+0i }}
{{ -12+0i }}
{{ 13+0i }}
{{ 0123 }}  0123
{{ -0x0 }}
{{ 0xdeadbeef }}

character constants
{{ 'a' }}
{{ '\n' }}
{{ '\\' }}
{{ '\'' }}
{{ '\xFF' }}
{{ '\u30d1' }}
{{ '\U000030d1' }}

some broken syntax
{{ +-2 }}
{{ 0x123. }}
{{ 1e. }}
{{ 0xi. }}
{{ 1+2. }}
{{ 'x }}
{{ 'xx' }}


https://go.dev/ref/spec#Integer_literals

{{ 42 }}
{{ 4_2 }}
{{ 0600 }}
{{ 0_600 }}
{{ 0o600 }}
{{ 0O600  }} // second character is capital letter 'O'
{{ 0xBadFace }}
{{ 0xBad_Face }}
{{ 0x_67_7a_2f_cc_40_c6 }}
{{ 170141183460469231731687303715884105727 }}
{{ 170_141183_460469_231731_687303_715884_105727 }}

{{ _42 }}         // an identifier, not an integer literal
{{ 42_ }}         // invalid: _ must separate successive digits
{{ 4__2 }}        // invalid: only one _ at a time
{{ 0_xBadFace }}  // invalid: _ must separate successive digits

{{ 0. }}
{{ 72.40 }}
{{ 072.40 }}       // == 72.40
{{ 2.71828 }}
{{ 1.e+0 }}
{{ 6.67428e-11 }}
{{ 1E6 }}
{{ .25 }}
{{ .12345E+5 }}
{{ 1_5. }}         // == 15.0
{{ 0.15e+0_2 }}    // == 15.0

{{ 0x1p-2 }}       // == 0.25
{{ 0x2.p10 }}      // == 2048.0
{{ 0x1.Fp+0 }}     // == 1.9375
{{ 0X.8p-0 }}      // == 0.5
{{ 0X_1FFFP-16 }}  // == 0.1249847412109375
{{ 0x15e-2 }}      // == 0x15e - 2 (integer subtraction)

{{ 0x.p1 }}        // invalid: mantissa has no digits
{{ 1p-2 }}         // invalid: p exponent requires hexadecimal mantissa
{{ 0x1.5e-2 }}     // invalid: hexadecimal mantissa requires p exponent
{{ 1_.5 }}         // invalid: _ must separate successive digits
{{ 1._5 }}         // invalid: _ must separate successive digits
{{ 1.5_e1 }}       // invalid: _ must separate successive digits
{{ 1.5e_1 }}       // invalid: _ must separate successive digits
{{ 1.5e1_ }}       // invalid: _ must separate successive digits

{{ 0i  }}
{{ 0123i }}        // == 123i for backward-compatibility
{{ 0o123i }}       // == 0o123 * 1i == 83i
{{ 0xabci }}        // == 0xabc * 1i == 2748i
{{ 0.i }}
{{ 2.71828i }}
{{ 1.e+0i }}
{{ 6.67428e-11i }}
{{ 1E6i }}
{{ .25i }}
{{ .12345E+5i }}
{{ 0x1p-2i }}       // == 0x1p-2 * 1i == 0.25i

{{ 'a' }}
{{ 'ä' }}
{{ '本' }}
{{ '\t' }}
{{ '\000' }}
{{ '\007' }}
{{ '\377' }}
{{ '\x07' }}
{{ '\xff' }}
{{ '\u12e4' }}
{{ '\U00101234' }}
{{ '\'' }}         // rune literal containing single quote character
{{ 'aa' }}         // illegal: too many characters
{{ '\k' }}         // illegal: k is not recognized after a backslash
{{ '\xa' }}        // illegal: too few hexadecimal digits
{{ '\0' }}         // illegal: too few octal digits
{{ '\400' }}       // illegal: octal value over 255
{{ '\uDFFF' }}     // illegal: surrogate half
{{ '\U00110000' }} // illegal: invalid Unicode code point
