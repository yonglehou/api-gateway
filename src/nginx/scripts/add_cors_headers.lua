local cors = require("cors")

cors.add_origin_to_vary_header(ngx)

-- set or override allow header 
cors.set_whitelisted_allow_origin_header(ngx, true)
