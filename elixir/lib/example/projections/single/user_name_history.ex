defmodule Example.Projections.Single.UserNameHistory do
  alias Example.Events.User.{UserCreated, UserNameChanged}

  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :names, list(String.t())
  end

  alias Example.Events.User.UserNameChanged

  def build(nil, %UserCreated{} = event) do
    name = %{first_name: event.first_name, last_name: event.last_name}

    state = %__MODULE__{
      id: event.id,
      names: [name]
    }

    stats = %Stoat.Projection.Stats{
      count: 0
    }

    %Stoat.Projection{
      state: state,
      stats: stats
    }
  end

  def build(proj, %UserNameChanged{} = event) do
    name = %{first_name: event.first_name, last_name: event.last_name}
    state = Map.update!(proj.state, :names, &[name | &1])
    Map.put(proj, :state, state)
  end

  def build(proj, _event), do: proj
end
