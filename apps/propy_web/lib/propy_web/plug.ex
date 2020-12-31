defmodule PropyWeb.Plug do
  use Plug.Router

  
  plug Plug.Static,
    at: "/",
    from: :propy_web # if i use tupple i need to put assets in lib/propy_web
    # only: ~w(css fonts images js favicon.ico robots.txt index.html)
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, "priv/static/index.html")
  end

  match _ do
    send_resp(conn, :not_found, "")
  end

  #custom mix task that will copy before mix release the static things
  #preko parametra posljem kje je lokacija - mix task je dober za to, ker lahko uporabim config pomoje oz 
  # Application.app_dir, ker potem dejansko vzamem preko parametra folder kjer je source in to je to, dest je tale variabla
end