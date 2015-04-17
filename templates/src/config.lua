-- templatized configuration: DO NOT EDIT
--
local config = {
  SERVICE_LB_URL = "{{key "config/api-gateway/SERVICE_LB_URL"}}",
  HELIOS_URL = "{{key "config/api-gateway/HELIOS_URL"}}",
  SERVICE_HTTP_TIMEOUT = 0.1,
}

return config
