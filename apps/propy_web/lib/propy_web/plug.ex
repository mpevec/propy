defmodule PropyWeb.Plug do
  use Plug.Router
  require Logger

  forward("/api",
    to: ReverseProxyPlug,
    upstream: &__MODULE__.get_upstream/0,
    error_callback: &__MODULE__.log_reverse_proxy_error/1
  )

  plug Plug.Static,
    at: "/",
    from: :propy_web # if i use tupple i need to put assets in lib/propy_web
    # only: ~w(css fonts images js favicon.ico robots.txt index.html)
  plug(:match)
  plug(:dispatch)

  # Because its SPA we always serve index page
  match _ do
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, Application.app_dir(:propy_web, "priv/static/index.html"))
  end

  def get_upstream do
    # "http://docker:4001/api"
    Application.fetch_env!(:propy_web, :upstream)
  end

  def log_reverse_proxy_error(error) do
    Logger.error("Network error: #{inspect(error)}")
  end

end