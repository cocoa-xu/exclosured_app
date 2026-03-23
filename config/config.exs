import Config

config :exclosured_app, ExclosuredAppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [formats: [html: ExclosuredAppWeb.ErrorHTML], layout: false],
  pubsub_server: ExclosuredApp.PubSub,
  live_view: [signing_salt: "exclosured_app_salt"],
  secret_key_base: String.duplicate("exclosured_app_secret_key_base_", 3),
  http: [port: 4000],
  server: true

config :logger, level: :info
config :phoenix, :json_library, Jason
