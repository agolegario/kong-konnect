local kong   = kong
local jwt    = require "resty.jwt"
local jwe    = require "kong.enterprise_edition.jwe"
local cjson  = require "cjson.safe"
local name   = "jwe-encryption"

local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1",
}

local exp    = os.time()

function plugin:access(config)
  if config.debug then
    kong.log.inspect("config", config)
    kong.log.inspect("timestamp", os.time())
    kong.log.inspect("local", os.date("%Y-%m-%d %H:%M:%S", exp))
  end

  local claims = config.payload
  if not claims.exp then
    claims.iat = exp
    claims.exp = exp + config.ttl
  end
  local jwt_token = jwt:sign(
    config.private_key,
    {
      header = { typ = "JWT", alg = "RS256" },
      payload = claims
    }
  )

  -- alg: gerenciamento de chave | enc: cifragem de conteúdo
  local jwe_token, err = jwe.encrypt("RSA-OAEP", "A256GCM", config.public_key, jwt_token)
  if not jwe_token then
    kong.log.err("encrypt failed: ", err);
    kong.response.exit(500, err)
  end

  -- Ex.: devolver ao cliente num cabeçalho ou corpo
  kong.response.exit(200, { jwe = jwe_token, jwt = jwt_token })
end --]]

return plugin
