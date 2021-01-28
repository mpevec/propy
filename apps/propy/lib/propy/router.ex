defmodule Propy.Router do
  @moduledoc """
    Basic router for this app
  """
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  import Plug.Conn

  forward("/api/greetings", to: Greetings)
  forward("/api/login", to: Login)

  plug(Plug.Logger, log: :debug)
  plug(:match)
  # put that in module const like u have required fields
  # plug(JwtExample.Plug.Auth, public_paths: ["/api/login", "/api/login/refresh_token"])
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )
  plug(:dispatch)

  match _ do
    send_resp(conn, :not_found, "")
  end
end
