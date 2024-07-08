defmodule ClocktownWeb.CounterLive do
  use ClocktownWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <p class="my-2 text-2xl text-center">
        <%= @count %>
      </p>
      <button phx-click="tick" class="mb-5 bg-blue-500 hover:bg-blue-400 text-white font-bold py-2 px-4 border-b-4 border-blue-700 hover:border-blue-500 rounded">
        Tick +
      </button>
      <%= render_chart_svg(@history) %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Clocktown.PubSub, "counter")
    Phoenix.PubSub.subscribe(Clocktown.PubSub, "history")
    socket = socket
      |> assign(:count, Clocktown.Counter.check())
      |> assign(:history, [0])
    {:ok, socket, layout: false}
  end

  def handle_event("tick", _params, socket) do
    Clocktown.Counter.tick()
    {:noreply, socket}
  end

  def handle_info({:update, count}, socket) do
    {:noreply, update(socket, :count, fn _count -> count end)}
  end

  def handle_info({:history, history}, socket) do
    {:noreply, update(socket, :history, fn _history -> history end)}
  end

  defp render_chart_svg(data) do
    sparkline = Contex.Sparkline.new(data)
    %Contex.Sparkline{sparkline | width: 600, height: 50}
      |> Contex.Sparkline.draw()
  end
end
