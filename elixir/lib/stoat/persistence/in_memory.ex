defmodule Stoat.Persistence.InMemory do
  use Agent

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(_opts), do: Agent.start_link(fn -> %{events: []} end, name: __MODULE__)

  @spec load_aggregate(module, String.t()) :: Stoat.Aggregate.t()
  def load_aggregate(module, id) do
    id
    |> fetch_events()
    |> Enum.reduce(nil, fn event, agg ->
      apply(module, :build, [agg, event])
    end)
    |> case do
      nil -> nil
      agg -> Map.put(agg, :events, [])
    end
  end

  @spec load_projection(module) :: Stoat.Projection.t()
  def load_projection(module) do
    fetch_all_events()
    |> Enum.reduce(nil, fn event, proj ->
      apply(module, :build, [proj, event])
    end)
  end

  @spec commit(Stoat.Aggregate.t()) :: Stoat.Aggregate.t()
  def commit(%Stoat.Aggregate{} = agg) do
    events = Enum.reverse(agg.events)
    # Store the aggregates by id and a general list of events
    Agent.update(__MODULE__, fn state ->
      state
      |> Map.update!(:events, &(&1 ++ events))
      |> Map.update(agg.id, events, &(&1 ++ events))
      |> IO.inspect()
    end)

    Map.put(agg, :events, [])
  end

  @spec fetch_events(String.t()) :: list(struct)
  def fetch_events(id) do
    Agent.get(__MODULE__, &Map.get(&1, id, []))
  end

  @spec fetch_all_events() :: list(struct)
  def fetch_all_events() do
    Agent.get(__MODULE__, & &1.events)
  end
end
