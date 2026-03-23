defmodule ExclosuredAppWeb.LandingController do
  use Phoenix.Controller, formats: [:html]

  def index(conn, _params) do
    conn
    |> put_layout(html: {ExclosuredAppWeb.Layouts, :app})
    |> render(:index)
  end
end
