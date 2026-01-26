defmodule LaapsWeb.PageController do
  use LaapsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
