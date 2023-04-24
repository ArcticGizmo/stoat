defmodule Example do
  alias Example.Aggregates.User

  def commit(agg), do: Stoat.Persistence.InMemory.commit(agg)

  def load_user(id), do: Stoat.Persistence.InMemory.load(User, id)

  def test_user() do
    User.create("Jon", "Doe")
    |> User.login()
    |> User.login()
    |> User.logout()
    |> User.login()
  end

  def test() do
    log("user 1 created")

    user_1 =
      test_user()
      |> IO.inspect()

    log("user 2 created")

    user_2 =
      User.create("User 2", "lastname")
      |> User.login()

    log("User 1 committed")

    user_1 =
      commit(user_1)
      |> IO.inspect()

    log("User 2 committed")

    user_2 =
      commit(user_2)
      |> IO.inspect()

    log("Load copy of user 1")
    user_1_copy = load_user(user_1.id)
  end

  defp log(msg), do: IO.puts("======= #{msg} =======")
end
