import Config
config :stoat, ecto_repos: [Stoat.Repo]

config :stoat, Stoat.Repo,
  database: "stoat_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
