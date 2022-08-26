defmodule MyLive.Repo do
  use Ecto.Repo,
    otp_app: :my_live,
    adapter: Ecto.Adapters.SQLite3
end
