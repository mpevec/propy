defmodule Login do
  @moduledoc """
    Login API
  """
  use Plug.Router

  import Plug.Conn

  alias Propy.Domain.UserAuthentication
  alias Propy.Model.Credentials
  alias Propy.Model.Token

  # Altough we can have only one pipeline in app (defined in router.ex), we ALWAYS need to have these two plugs defined when using Plug.Router
  plug(:match)
  plug(:dispatch)

  post "/" do
    Credentials.to_struct!(conn.body_params)
    |> UserAuthentication.authenticate
    |> respond(conn)
  end

  get "/refresh_token" do
    fetch_cookies(conn)
    |> get_request_cookie("refresh_token")
    |> UserAuthentication.refresh
    |> respond(conn)
  end

  # for cases like /login/...
  match _ do
    send_resp(conn, :not_found, "")
  end

  defp get_request_cookie(%Plug.Conn{cookies: cookies}, cookie) do
    Map.get(cookies, cookie)
  end

  defp respond({:ok, %Token{jwt: jwt, uuid: uuid}}, %Plug.Conn{} = conn) do
    conn = put_resp_cookie(conn, "refresh_token", uuid)
    send_resp(conn, :ok, Jason.encode!(%{jwt: jwt}))
  end

  defp respond({:error, error}, %Plug.Conn{} = conn) do
    send_resp(conn, :unauthorized, Jason.encode!(%{error: error}))
  end
end
