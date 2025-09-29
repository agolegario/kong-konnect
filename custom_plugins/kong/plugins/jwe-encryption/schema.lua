local typedefs = require "kong.db.schema.typedefs"

return {
  name = "jwe-encryption",
  fields = {
    { protocols = typedefs.protocols },
    {
      config = {
        type = "record",
        fields = {
          {
            private_key = {
              type = "string",
              required = false,
              referenceable = true,
              default = "{vault://global/bd.security.msso.private.key}",
              description = "Chave privada (PEM) utilizada para criptografar o JWE",
            },
          },
          {
            public_key = {
              type = "string",
              required = false,
              referenceable = true,
              default = "{vault://global/bd.security.msso.public.key}",
              description = "Chave publica (PEM) utilizada para decriptar o JWE",
            },
          },
          {
            payload = {
              type = "record",
              required = true,
              description = "Payload do JWT (claims)",
              fields = {
                { sub = { type = "string", required = true } },
                { name = { type = "string", required = true } },
                { scope = { type = "string", required = true } },
              },
            }
          },
          { ttl = { type = "number", required = true, default = 1200, description = "Validade em segundos do token" } },
          {
            debug = {
              type = "boolean",
              default = true,
              description = "Ativa logs extras de depuracao",
            },
          },
        },
      },
    },
  },
}
