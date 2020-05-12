{{- define "setDefaults" }}

{{/* create list of apps */}}
{{- $apps := list }}

{{- range .Values.applications }}
{{/* apply defaults to application */}}
{{- $app := mustMerge . $.Values.application_defaults }}

{{/* globally set app tag */}}
{{- if not $app.tag }}
{{- $_ := set $app "tag" $.Values.image_tag }}
{{- end }}

{{/* Set Certificate Issuer for each host */}}
{{- if $app.ingress }}
{{- range $app.ingress.hosts }}
{{- if not .issuer_name }}
{{- $_ := set . "issuer_name" $.Values.issuer_name }}
{{- end }}
{{- if not .issuer_kind }}
{{- $_ := set . "issuer_kind" $.Values.issuer_kind }}
{{- end }}
{{- end }}
{{- end }}

{{/* add defaulted application to final list */}}
{{- $apps = mustAppend $apps $app }}
{{- end }}

{{/* persist list of apps */}}
{{- $_ := set . "apps" $apps }}


{{/* create list of cronjobs */}}
{{- $cronjobs := list }}

{{- range .Values.cronjobs }}
{{/* apply defaults to cronjobs */}}
{{- $cronjob := mustMerge . $.Values.cronjob_defaults }}

{{/* globally set app tag */}}
{{- if not $cronjob.tag }}
{{- $_ := set $cronjob "tag" $.Values.image_tag }}
{{- end }}

{{/* add defaulted cronjobs to final list */}}
{{- $cronjobs = mustAppend $cronjobs $cronjob }}
{{- end }}

{{/* persist list of cronjobs */}}
{{- $_ := set . "cronjobs" $cronjobs }}

{{- end }}
