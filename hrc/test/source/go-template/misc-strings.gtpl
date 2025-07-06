https://go.dev/ref/spec#String_literals

{{ `abc` }}                 // same as "abc"
{{ `\n
\n` }}                  // same as "\\n\n\\n"
{{ "\n" }}
{{ "\"" }}                 // same as `"`
{{ "Hello, world!\n" }}
{{ "日本語" }}
{{ "\u65e5本\U00008a9e" }}
{{ "\xff\u00FF" }}
{{ "\uD800" }}             // illegal: surrogate half
{{ "\U00110000" }}         // illegal: invalid Unicode code point

{{ "日本語" }}                                 // UTF-8 input text
{{ `日本語` }}                                 // UTF-8 input text as a raw literal
{{ "\u65e5\u672c\u8a9e" }}                    // the explicit Unicode code points
{{ "\U000065e5\U0000672c\U00008a9e" }}        // the explicit Unicode code points
{{ "\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e" }}  // the explicit UTF-8 bytes