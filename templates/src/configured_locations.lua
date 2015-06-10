{{define "escape"}}{{.| regexReplaceAll "[^a-zA-Z0-9]" "_"}}{{end}}
{{define "urlEscape"}}{{.| regexReplaceAll "[^a-zA-Z0-9-_.]" "_"}}{{end}}
local url_routes = {}
{{range $item := tree "auto_discovery/services"}}
{{ if $item.Key | regexMatch ".*/.*" }}{{else}}{{ if $item.Key | regexMatch ".+"}}
url_routes["{{template "urlEscape" $item.Key}}"] =  "{{template "escape" $item.Value }}"
{{end}}{{end}}
{{end}}
return url_routes
