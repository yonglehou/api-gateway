{{$env := env "WIKIA_ENVIRONMENT"}}{{$gatewayTree := printf "registry/%s/api-gateway" $env}}
local url_routes = {}
{{range $item := tree $gatewayTree }}{{$key := $item.Key | regexReplaceAll "[^a-zA-Z0-9-_.]" "_"}}
url_routes["{{$key}}"] =  "{{$key}}"
{{end}}
return url_routes
