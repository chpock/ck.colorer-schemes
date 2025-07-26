https://github.com/chpock/ck.colorer-schemes/issues/17

{{ print nil nil }}
{{ print false false }}
{{ print true true }}
{{ print "%s" nil true false }}

https://github.com/chpock/ck.colorer-schemes/issues/21

'nil' is not available in variable assignment, see: https://github.com/golang/go/issues/57773
{{ $var := nil }}

However, this is fully correct:
{{ $var := nil | printf "%s" }}