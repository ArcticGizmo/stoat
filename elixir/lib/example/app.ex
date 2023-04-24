defmodule Example.App do
  use Application

  def start(_type, _args) do
    children = [Stoat.Persistence.InMemory]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
