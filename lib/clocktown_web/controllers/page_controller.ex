defmodule ClocktownWeb.PageController do
  use ClocktownWeb, :controller
  import Phoenix.LiveView.Controller

  def home(conn, _params) do
    live_render(conn, ClocktownWeb.CounterLive)
  end
end
