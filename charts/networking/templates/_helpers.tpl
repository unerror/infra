{{/*
Expand the name of the chart.
*/}}
{{- define "networking.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "networking.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "networking.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "networking.labels" -}}
helm.sh/chart: {{ include "networking.chart" . }}
{{ include "networking.selectorLabels.provisioner" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "networking.selectorLabels.provisioner" -}}
app.kubernetes.io/name: {{ include "networking.name" . }}
app.kubernetes.io/component: provisioner
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "networking.selectorLabels.s3" -}}
app.kubernetes.io/name: {{ include "networking.name" . }}
app.kubernetes.io/component: provisioner
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "networking.selectorLabels.attacher" -}}
app.kubernetes.io/name: {{ include "networking.name" . }}
app.kubernetes.io/component: attacher
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}