defmodule Stoat.Aggregate do
  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :state, struct
    field :is_deleted, struct
    field :events, list(struct)
  end
end
