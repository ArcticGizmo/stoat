defmodule Stoat.Event do
  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :sequence, integer
    field :state, struct
    field :timestamp, NaiveDateTime
  end
end
