defmodule Laaps.Repo do
  use Ecto.Repo,
    otp_app: :laaps,
    adapter: Ecto.Adapters.SQLite3
end
