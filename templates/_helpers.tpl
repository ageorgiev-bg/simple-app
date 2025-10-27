{{- define "simple-app.fullname" -}}
{{- $defaultName := printf "%s-%s" .Release.Name .Chart.Name }}
{{- .Values.customName | default $defaultName | trunc 63 | trimSuffix "-"  -}}
{{- end -}}

{{- define "simple-app.selectorLabels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
managed-by: "helm"
{{- end -}}

{{/*As context pass an integer or string*/}}
{{- define "simple-app.validators.portRange" -}}
{{- $sanitizedPort := int . -}}
{{/*Port validation*/}}
{{- if or (lt $sanitizedPort 1) (gt $sanitizedPort 65535) -}}
{{- fail "Allowed port range: 1-65535." -}}
{{- end -}}
{{- end -}}

{{/*As context pass an object with port and type*/}}
{{- define "simple-app.validators.service" -}}
{{- include "simple-app.validators.portRange" .port -}}

{{- end -}}

{{/*Service type validation*/}}
{{- $allowedSvcType := "ClusterIP" -}}
{{- if not (has .type $allowedSvcType) -}}
{{- fail (printf "Invalid service type %s. Supported value is: %s" .type $allowedSvcType) -}}
{{- end -}}