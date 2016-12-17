defmodule Eddyweb.PageController do
  use Eddyweb.Web, :controller

  def index(conn, _params) do
    Auth.register()
    Auth.signin()
    render conn, "index.html"
  end
end
