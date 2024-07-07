defmodule Clocktown.Counter do
  use GenServer

  def start_link(n \\ 0) do
    GenServer.start_link(__MODULE__, n, name: __MODULE__)
  end

  def init(n) do
    {:ok, n}
  end

  def tick do
    GenServer.cast(__MODULE__, :tick)
  end

  def check do
    GenServer.call(__MODULE__, :check)
  end

  def handle_call(:check, _from, count) do
    {:reply, count, count}
  end

  def handle_cast(:tick, count) do
    count = count + 1
    Phoenix.PubSub.broadcast(Clocktown.PubSub, "counter", {:update, count})
    {:noreply, count}
  end
end
