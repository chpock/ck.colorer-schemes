
{{ $a := "fooo" | printf }}
{{ 'd' | printf }}

{{printf "%q" "output"}}
{{ $var$%^&#$$% }} <- error here

this is "-23" but not {{- 23 }}
{{-23}}

{{with $x := 3}}{{$x 23}}{{end}}

{{$x := 3}}
{{with $x := 3}}{{$x 23}}

{{- include "common.tplvalues.render" (dict "value" . "context" $) | nindent 8 }}

{{ $.context.Release.Namespace }}

{{ .Field }}
{{ .Field1.Field2 }}

{{ $variable }}
{{ $variable.Field }}
{{ $variable.Field1.Field2 }}

{{ or .A .B }}
{{ .Method .C .D }}


{{ "output" }}
{{- " demonstrates" }}
{{/* it has a comment */}}
{{ "output" | print }}
{{ $A := "assigns variables" }}{{ $A }}.
{{ $B := 2 }}{{ if eq $B 1 }}{{ else }}{{ end }}

{{(printf .Field1.Field2.Field3).Value}}
{{$x := (printf .Field1.Field2.Field3).Value}}
{{$y := (printf $x.Field1.Field2.Field3).Value}}
{{$z := $y.Field1.Field2.Field3}}
{{if contains $y $z}}
	{{printf "%q" $y}}
{{else}}
	{{printf "%q" $x}}
{{end}}
{{with $z.Field1 | contains "boring"}}
	{{printf "%q" . | printf "%s"}}
{{else}}
	{{printf "%d %d %d" 11 11 11}}
	{{printf "%d %d %s" 22 22 $x.Field1.Field2.Field3 | printf "%s"}}
	{{printf "%v" (contains $z.Field1.Field2 $y)}}
{{end}}

errors: pipeline should not start with pipe
{{ | if }}
{{ if | error here }}
{{ with | | | error here }}

errors: wrong bin integer
{{ 0b01501 | $var }}
{{ 0b01a01 | 0b10 }}
{{ 0b01a01 }}
