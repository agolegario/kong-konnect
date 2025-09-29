local kong   = kong
local jwe    = require "kong.enterprise_edition.jwe"
local name   = "jwe-decryption"

local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1",
}

function plugin:strip_bearer(token)
  if not token then
    return nil
  end
  local cleaned = token:gsub("^[Bb]earer%s+", "")
  return cleaned
end

function plugin:access(config)
  if config.debug then
    kong.log.inspect("config", config)
    kong.log.inspect("local", os.date("%Y-%m-%d %H:%M:%S", os.time()))
  end

  local header_value = kong.request.get_header(config.header_name)
  if not header_value then
    return kong.response.exit(400, { message = "Missing JWE in header " .. config.header_name })
  end

  local jwe_token = self:strip_bearer(header_value)
  if not jwe_token then
    return kong.response.exit(400, { message = "Bad Request" })
  end


  local plaintext, err = jwe.decrypt(config.private_key, jwe_token)
  if not plaintext then
    return kong.response.exit(401, { message = "JWE decryption failed", error = err })
  end

  kong.ctx.shared[config.variavel_de_contexto] = plaintext

  if config.debug then
    kong.log.inspect("contexto", kong.ctx.shared[config.variavel_de_contexto])
  end
end --]]

return plugin
