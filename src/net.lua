-- package net

local http = require "resty.http"

function http.request(url, request_method, request_headers, body)
	if not request_headers then
		request_headers = {}
		request_headers["host"] = nil
	end

	local httpc = http.new()
	local res, err = httpc:request_uri(url,
	{
		method = request_method,
		headers = request_headers,
		body = body
	})

	return res, err
end

function http.get(url, headers)
	return request(url, "GET", headers)
end

return http
