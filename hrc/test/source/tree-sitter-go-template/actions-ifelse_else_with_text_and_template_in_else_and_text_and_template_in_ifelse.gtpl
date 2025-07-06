
{{if pipeline}} t1 {{ else if pipeline }} test {{ .Values.test }} {{ else }} t3 {{ .Values.test }} {{ end }}