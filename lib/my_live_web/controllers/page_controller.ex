defmodule MyLiveWeb.PageController do
  use MyLiveWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
