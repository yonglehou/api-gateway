{{define "escape"}}{{.| regexReplaceAll "[^a-zA-Z0-9]" "_"}}{{end}}
{{define "urlEscape"}}{{.| regexReplaceAll "[^a-zA-Z0-9-_.]" "_"}}{{end}}
local url_routes = {}
{{range $service := services}}
{{range $tag := $service.Tags}}{{with $serviceQuery := printf "%s.%s" $tag $service.Name}}
{{if eq $tag "expose.production"}}
url_routes["{{template "urlEscape" $service.Name}}"] = "{{template "escape" $serviceQuery}}"{{else}}
{{if $tag | regexMatch "^expose.*"}}
url_routes["{{template "removeExposeAndEscape" $tag}}.{{template "urlEscape" $service.Name}}"] = "{{template "escape" $serviceQuery}}"
{{end}}{{end}}{{end}}{{end}}{{end}}
return url_routes
