defmodule ClocktownWeb.CounterLive do
  use ClocktownWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <p class="my-2 text-2xl text-center">
        <%= @count %>
      </p>
      <button phx-click="tick" class="bg-blue-500 hover:bg-blue-400 text-white font-bold py-2 px-4 border-b-4 border-blue-700 hover:border-blue-500 rounded">
        Tick +
      </button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Clocktown.PubSub, "counter")
    {:ok, assign(socket, :count, Clocktown.Counter.check()), layout: false}
  end

  def handle_event("tick", _params, socket) do
    Clocktown.Counter.tick()
    {:noreply, socket}
  end

  def handle_info({:update, count}, socket) do
    {:noreply, update(socket, :count, fn _count -> count end)}
  end
end
