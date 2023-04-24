defmodule Example do
  alias Example.Aggregates.User
  alias Example.Projections.Multi.UserCount
  alias Example.Projections.Single.UserNameHistory

  def commit(agg), do: Stoat.Persistence.InMemory.commit(agg)

  def load_user(id), do: Stoat.Persistence.InMemory.load_aggregate(User, id)

  def test_user() do
    User.create("Jon", "Doe")
    |> User.login()
    |> User.change_name("Jon", "Donut")
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
      |> User.logout()

    log("User 1 committed")

    user_1 =
      commit(user_1)
      |> IO.inspect()

    log("User 2 committed")

    user_2 =
      commit(user_2)
      |> IO.inspect()

    log("Load copy of user 1")
    load_user(user_1.id) |> IO.inspect()

    log("Load user count projection")
    load_user_count() |> IO.inspect()

    log("load user name histories")
    load_user_name_history(user_1.id) |> IO.inspect()
    load_user_name_history(user_2.id) |> IO.inspect()

    %{user_1_id: user_1.id, user_2_id: user_2.id}
  end

  def load_user_count() do
    Stoat.Persistence.InMemory.load_projection(UserCount)
  end

  def load_user_name_history(id) do
    Stoat.Persistence.InMemory.load_projection(UserNameHistory, id)
  end

  defp log(msg), do: IO.puts("======= #{msg} =======")
end
