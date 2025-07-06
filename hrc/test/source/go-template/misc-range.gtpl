{{ range .Value }}
  xxxx
    xxxx
  xxx
{{ end }}
{{- range .Value }} xxx {{ end -}}

{{ range .Value }}
  xxx
    xxxx
  xxxx
{{ else }}
  xxx
    xxx
  xxx
{{ end }}
{{ range $variable }} xxx {{ else }} xxx {{ end }}

{{ range $index, $element := .Value }}
  xxx
{{ end }}

{{- range (len . | dec | slice . ) }}
