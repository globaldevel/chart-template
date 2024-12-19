{{/* Definicion para la creacion de la URL de imagen */}}
{{- define "deployment.imageURL" -}}
{{- $env := .Values.namespace | default "environment" }}
{{- $urlProd := "acrprod.azurecr.io" }}
{{- $urlDev := "acrdev.azurecr.io" }}
{{- $urlLab := "acrlab.azurecr.io" }}
{{- $app := .Values.release.image | default "gs-dso-ms-test:latest" }}
{{- if or (eq $env "lab") }}
  {{- printf "%s/%s" $urlLab $app }}
{{- else if or (eq $env "develop") (eq $env "test") (eq $env "stage") }}
  {{- printf "%s/%s" $urlDev $app }}
{{- else if eq $env "production" }}
  {{- printf "%s/%s" $urlProd $app }}
{{- end }}
{{- end -}}

{{- define "ingress.host" -}}
  {{- $namespace := .Values.namespace -}}
  {{- $hosts := dict "production" "cloud.svc.globaldevel.com" 
                       "lab" "lab.svc.globaldevel.com" 
                       "develop" "dev.svc.globaldevel.com" 
                       "test" "test.svc.globaldevel.com" 
                       "stage" "stage.svc.globaldevel.com" -}}
  {{- index $hosts $namespace | default "default-cloud.svc.globaldevel.com" -}}
{{- end -}}

{{- define "resourceValues" -}}
  {{- if eq . "Tier1" }}
  limits:
    cpu: 100m
    memory: 150Mi
  requests:
    cpu: 50m
    memory: 100Mi
  {{- else if eq . "Tier2" }}
  limits:
    cpu: 200m
    memory: 500Mi
  requests:
    cpu: 150m
    memory: 300Mi
  {{- else if eq . "Tier3" }}
  limits:
    cpu: 500m
    memory: 1Gi
  requests:
    cpu: 250m
    memory: 800Mi
  {{- else if eq . "Custom" }}
  limits:
    cpu: {{ .Values.resources.limitsCPU }}
    memory: {{ .Values.resources.limitsMEM }}
  requests:
    cpu: {{ .Values.resources.requestsCPU }}
    memory: {{ .Values.resources.requestsMEM }}
  {{- end }}
{{- end }}