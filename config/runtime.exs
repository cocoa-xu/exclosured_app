import Config

if config_env() == :prod do
  secret =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      SECRET_KEY_BASE is not set.

      Generate one with `mix phx.gen.secret` and export it before starting.
      """

  config :exclosured_app, ExclosuredAppWeb.Endpoint,
    url: [host: System.get_env("PHX_HOST", "localhost"), scheme: "https", port: 443],
    http: [port: String.to_integer(System.get_env("PORT", "4000"))],
    secret_key_base: secret,
    check_origin: System.get_env("PHX_CHECK_ORIGIN", "true") != "false"
end
