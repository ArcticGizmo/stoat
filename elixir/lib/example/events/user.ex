defmodule Example.Events.User do
  use TypedStruct

  # TODO: create .t() type for ease of use

  typedstruct module: UserCreated, enforce: true do
    field :id, String.t()
    field :first_name, String.t()
    field :last_name, String.t()
  end

  typedstruct module: UserLoggedIn, enforce: true do
    field :id, String.t()
  end

  typedstruct module: UserLoggedOut, enforce: true do
    field :id, String.t()
  end

  typedstruct module: UserDeleted, enforce: true do
    field :id, String.t()
  end
end
