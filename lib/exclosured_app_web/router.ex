defmodule ExclosuredAppWeb.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :put_root_layout, html: {ExclosuredAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ExclosuredAppWeb do
    pipe_through :browser

    get "/", LandingController, :index
  end
end
