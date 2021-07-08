defmodule YoganDev.Repo.Cache.Synchronizer do
  alias YoganDev.Repo.Cache

  use GenServer

  @refresh_time :timer.seconds(1)

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl GenServer
  def init(opts) do
    cache = Keyword.fetch!(opts, :cache)

    send(self(), :sync)

    {:ok, cache}
  end

  @impl GenServer
  def handle_info(:sync, cache) do
    with {:ok, items} <- apply(cache, :fetch_fn, []).() do
      Cache.set_all(cache, items)
    end

    schedule(cache)

    {:noreply, cache}
  end

  defp schedule(_cache) do
    Process.send_after(self(), :sync, @refresh_time)
  end
end
