
{{if pipeline}} t1 {{ else if pipeline }} t2 {{ else }} {{ .Values.test }} test {{ end }}