defmodule Laaps.Game do
  alias Laaps.Game.Event
  alias Laaps.Repo

  import Ecto.Query

  def future_events() do
    utc_now = DateTime.utc_now()

    query = from e in Event, where: e.date > ^utc_now

    Repo.all(query)
  end
end
