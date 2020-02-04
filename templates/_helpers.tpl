{{- define "setApps" }}

{{/* create list of apps */}}
{{- $apps := list }}

{{- range .Values.applications }}
{{/* apply defaults to application */}}
{{- $app := mustMerge . $.Values.application-defaults }}

{{/* globally set app tag */}}
{{- if not $app.tag }}
{{- $_ := set $app "tag" $.Values.image_tag }}
{{- end }}

{{/* add defaulted application to final list */}}
{{- $apps = mustAppend $apps $app }}
{{- end }}

{{/* persist list of apps */}}
{{- $_ := set . "apps" $apps }}

{{- end }}

{{- define "setCronJobs" }}

{{/* create list of cronjobs */}}
{{- $cronjobs := list }}

{{- range .Values.cronjobs }}
{{/* apply defaults to cronjobs */}}
{{- $cronjob := mustMerge . $.Values.cronjob-defaults }}

{{/* add defaulted cronjobs to final list */}}
{{- $cronjobs = mustAppend $cronjobs $cronjob }}
{{- end }}

{{/* persist list of cronjobs */}}
{{- $_ := set . "cronjobs" $cronjobs }}

{{- end }}