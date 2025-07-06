
{{if pipeline}} t1 {{ else if pipeline }} t2 {{ else }} test {{ .Values.test }} {{ end }}