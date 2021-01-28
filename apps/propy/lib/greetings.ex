defmodule Greetings do
  @moduledoc """
    Greetings API
  """
  use Plug.Router

  import Plug.Conn

  # Altough we can have only one pipeline in app (defined in router.ex), we ALWAYS need to have these two plugs defined when using Plug.Router
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, :ok, "")
  end

  # for cases like /greetings/...
  match _ do
    send_resp(conn, :not_found, "")
  end

end
