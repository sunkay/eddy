defmodule Eddyweb.PageController do
  use Eddyweb.Web, :controller
  require Logger

  #plug :require_authenticated when action in [:index]

  def index(conn, _params) do
    render conn, "index.html"
  end

end
