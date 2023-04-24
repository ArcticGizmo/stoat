defmodule Example.Aggregates.User do
  alias Example.Events.User.{
    UserCreated,
    UserLoggedIn,
    UserLoggedOut,
    UserNameChanged,
    UserDeleted
  }

  use TypedStruct

  # This defines how units of state are generated

  typedstruct enforce: true do
    field :id, String.t()
    field :first_name, String.t()
    field :last_name, String.t()
    field :is_logged_in, boolean
  end

  # commands
  def create(first_name, last_name) do
    event = %UserCreated{
      id: Stoat.uuid(),
      first_name: first_name,
      last_name: last_name
    }

    build(nil, event)
  end

  def change_name(%Stoat.Aggregate{} = agg, first_name, last_name) do
    event = %UserNameChanged{
      id: agg.id,
      first_name: first_name,
      last_name: last_name
    }

    build(agg, event)
  end

  def login(%Stoat.Aggregate{} = agg) do
    if agg.state.is_logged_in do
      agg
    else
      event = %UserLoggedIn{
        id: agg.id
      }

      build(agg, event)
    end
  end

  def logout(%Stoat.Aggregate{} = agg) do
    if !agg.state.is_logged_in do
      agg
    else
      event = %UserLoggedOut{
        id: agg.id
      }

      build(agg, event)
    end
  end

  # aggregate builder path

  def build(nil, %UserCreated{} = event) do
    state = %__MODULE__{
      id: event.id,
      first_name: event.first_name,
      last_name: event.last_name,
      is_logged_in: false
    }

    %Stoat.Aggregate{
      id: state.id,
      state: state,
      is_deleted: false,
      events: [event]
    }
  end

  def build(agg, %UserNameChanged{} = event) do
    state = agg.state
    |> Map.put(:first_name, event.first_name)
    |> Map.put(:last_name, event.last_name)

    agg
    |> Map.put(:state, state)
    |> Map.update!(:events, &[event | &1])
  end

  def build(agg, %UserLoggedIn{} = event) do
    state = Map.put(agg.state, :is_logged_in, true)

    agg
    |> Map.put(:state, state)
    |> Map.update!(:events, &[event | &1])
  end

  def build(agg, %UserLoggedOut{} = event) do
    state = Map.put(agg.state, :is_logged_in, false)

    agg
    |> Map.put(:state, state)
    |> Map.update!(:events, &[event | &1])
  end

  def build(agg, %UserDeleted{} = event) do
    agg
    |> Map.put(:is_deleted, true)
    |> Map.update!(:events, &[event | &1])
  end
end
