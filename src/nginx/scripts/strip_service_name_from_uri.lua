local util = require("util")

--strip the service name prefix
local stripped_uri = util.get_rest_after_url_prefix(ngx.var.request_uri)

-- remove leading / so that there is no duplication of / when proxy pass is set to http://$x/$stripped_uri
return util.strip_leading_slash(stripped_uri)
