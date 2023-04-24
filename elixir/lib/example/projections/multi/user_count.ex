defmodule Example.Projections.Multi.UserCount do
  alias Example.Events.User
  use TypedStruct

  # this is an example of a multi_stream projection

  typedstruct enforce: true do
    field :users, integer
    field :logged_in, integer
  end

  def build(nil, event) do
    state = %__MODULE__{
      users: 0,
      logged_in: 0
    }

    stats = %Stoat.Projection.Stats{
      count: 0
    }

    %Stoat.Projection{
      state: state,
      stats: stats
    }
    |> build(event)
  end

  def build(proj, %User.UserCreated{}) do
    state = Map.update!(proj.state, :users, &(&1 + 1))
    Map.put(proj, :state, state)
  end

  def build(proj, %User.UserLoggedIn{}) do
    state = Map.update!(proj.state, :logged_in, &(&1 + 1))
    Map.put(proj, :state, state)
  end

  def build(proj, %User.UserLoggedOut{}) do
    state = Map.update!(proj.state, :logged_in, &(&1 - 1))
    Map.put(proj, :state, state)
  end

  # fallback
  def build(proj, _event), do: proj
end
