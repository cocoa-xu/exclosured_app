defmodule ExclosuredApp.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: ExclosuredApp.PubSub},
      ExclosuredAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ExclosuredApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
