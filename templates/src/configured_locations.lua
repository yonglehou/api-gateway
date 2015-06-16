{{define "escape"}}{{.| regexReplaceAll "[^a-zA-Z0-9]" "_"}}{{end}}
{{define "urlEscape"}}{{.| regexReplaceAll "[^a-zA-Z0-9-_.]" "_"}}{{end}}
local url_routes = {}
{{range $item := tree "auto_discovery/services"}}
{{ if $item.Key | regexMatch ".*/.*" }}{{else}}{{ if $item.Key | regexMatch ".+"}}
{{ if $item.Value | regexMatch ".*@.*"}}
{{/*
// if @ is present in the Value then it means its a cross dc query to support cross dc queries different
// set of upstream servers needs to be setup */}}
url_routes["{{template "urlEscape" $item.Key}}"] =  "{{template "escape" $item.Key }}_{{template "escape" $item.Value }}"
{{else}}
url_routes["{{template "urlEscape" $item.Key}}"] =  "{{template "escape" $item.Value }}"
{{end}}{{end}}{{end}}
{{end}}
return url_routes
