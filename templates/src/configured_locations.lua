{{define "escape"}}{{.| regexReplaceAll "[^a-zA-Z0-9]" "_"}}{{end}}
{{$env := env "WIKIA_ENVIRONMENT"}}{{$gatewayTree := printf "registry/%s/api-gateway" $env}}
{{/*
   * Creates a mapping between the service name (matched as the first part of
   * the URI) and an nginx-safe upstream name. Example:
   *
   *  # in consul
   *  /registry/dev/api-gateway/auth => dev.helios
   *
   *  # here
   *  url_routes["auth"] = "dev_helios"
   *
   *  # nginx
   *  upstream dev_helios { }
   *
   *  The intention here is to create a config that will map intuitively to a consul address.
   */}}
local url_routes = {}
{{range $item := tree $gatewayTree}}{{$key := $item.Key | regexReplaceAll "[^a-zA-Z0-9-_.]" "_"}}
{{with $queryResult := service $item.Value}}{{if $queryResult}}{{/* make sure there are services registered */}}
url_routes["{{$key}}"] =  "{{template "escape" $item.Value}}" -- {{$item.Value}}.service.consul
{{end}}{{end}}{{end}}
return url_routes
