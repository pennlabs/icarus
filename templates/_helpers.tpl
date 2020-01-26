{{- define "setApps" }}

{{/* create list of apps */}}
{{- $apps := list }}

{{- range .Values.applications }}
{{/* apply defaults to application */}}
{{- $app := mustMerge . $.Values.defaults }}

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