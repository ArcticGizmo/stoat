defmodule Stoat.Projection do
  use TypedStruct

  typedstruct enforce: true do
    field :state, struct
    field :stats, Stats
  end

  typedstruct module: Stats, enforce: true do
    field :count, integer
  end
end
