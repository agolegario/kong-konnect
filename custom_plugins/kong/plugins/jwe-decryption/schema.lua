local typedefs = require "kong.db.schema.typedefs"

return {
  name = "jwe-decryption",
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
            header_name = {
              type = "string",
              required = true,
              default = "x-jwe-token",
              description = "Nome do header do request que contem o JWE"
            },
          },
          {
            variavel_de_contexto = {
              type = "string",
              required = true,
              default = "field",
              description = "Nome da variavel de contexto que quer armazenar o valor decriptado"
            },
          },
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
