local cors = require("cors")

cors.add_origin_to_vary_header(ngx)

cors.set_whitelisted_control_headers(ngx)
