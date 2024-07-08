defmodule Clocktown.History do
  use GenServer

  def start_link(size \\ 50, rate \\ :timer.seconds(1)) do
    GenServer.start_link(__MODULE__, {size, rate}, name: __MODULE__)
  end

  def init({size, rate}) do
    Phoenix.PubSub.subscribe(Clocktown.PubSub, "counter")
    schedule_push(rate)
    {:ok, {List.duplicate(0, size), rate}}
  end

  def handle_info({:update, _count}, {[n | history], rate}) do
    {:noreply, {[n + 1 | history], rate}}
  end

  def handle_info(:push, {history, rate}) do
    Phoenix.PubSub.broadcast(Clocktown.PubSub, "history", {:history, history})
    schedule_push(rate)
    {:noreply, {[0 | Enum.take(history, length(history) - 1)], rate}}
  end

  defp schedule_push(rate) do
    Process.send_after(self(), :push, rate)
  end
end
