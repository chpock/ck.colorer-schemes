{{with "output"}}
{{- . -}}
{{ end }}
{{- with $x := "output" }}{{$x}}{{ end -}}

{{with .Data}}
  {{- . -}}
{{ else }}
  {{- "no data" -}}
{{ end }}