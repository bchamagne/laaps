defmodule Laaps.Game do
  alias Laaps.Game.Event
  alias Laaps.Repo

  import Ecto.Query

  def future_events() do
    utc_now = DateTime.utc_now()

    query = from e in Event, where: e.date > ^utc_now

    Repo.all(query)
  end

  def participants(e) do
    e.participants
    |> Enum.map(&Event.decode_participant/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def add_participant(e, name, count) do
    e
    |> Event.changeset(%{})
    |> Event.add_participant(name, count)
    |> Repo.update()
  end
end
