defmodule PropyWeb.Plug do
  use Plug.Router

  plug Plug.Static,
    at: "/",
    from: :propy_web # if i use tupple i need to put assets in lib/propy_web
    # only: ~w(css fonts images js favicon.ico robots.txt index.html)
  plug(:match)
  plug(:dispatch)

  # Because its SPA we always serve index page
  match _ do
    # send_resp(conn, :not_found, "")
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, "priv/static/index.html")
  end

end