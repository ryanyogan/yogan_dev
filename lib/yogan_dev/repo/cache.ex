defmodule YoganDev.Repo.Cache do
  use GenServer

  @callback table_name :: atom()
  @callback start_link(keyword()) :: GenServer.on_start()

  @impl GenServer
  def init(name) do
    name
    |> table_for()
    |> :ets.new([:ordered_set, :protected, :named_table])

    {:ok, %{name: name}}
  end

  def all(cache) do
    cache
    |> table_for()
    |> :ets.tab2list()
    |> case do
      values when values != [] ->
        {:ok, Enum.map(values, &elem(&1, 1))}

      _ ->
        {:error, :not_found}
    end
  end

  def get(cache, key) do
    cache
    |> table_for()
    |> :ets.lookup(key)
    |> case do
      [{^key, value} | _] ->
        {:ok, value}

      _ ->
        {:error, :not_found}
    end
  end

  def set_all(cache, items), do: GenServer.cast(cache, {:set_all, items})

  def set(cache, id, item), do: GenServer.cast(cache, {:set, id, item})

  @impl GenServer
  def handle_cast({:set_all, items}, %{name: name} = state)
      when is_list(items) do
    Enum.each(items, &:ets.insert(table_for(name), {&1.id, &1}))

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:set, id, item}, %{name: name} = state)
      when is_list(item) do
    name
    |> table_for()
    |> :ets.insert({id, item})

    {:noreply, state}
  end

  defp table_for(name), do: apply(name, :table_name, [])
end
