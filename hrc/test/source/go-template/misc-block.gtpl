{{ block "name" .Data }}
  xxxx
    xxxx
  xxx
{{ end }}
{{- block "name" .Data }} xxx {{ end -}}

{{define "name"}}
  xxxx
    xxxx
  xxx
{{ end }}
{{- define "name"}} xxx {{end -}}

{{template "name"}}
{{template "name" .Value}}
