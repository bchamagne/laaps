defmodule Laaps.Game do
  alias Laaps.Game.Event
  alias Laaps.Game.News
  alias Laaps.Repo

  import Ecto.Query

  def news() do
    query = from n in News, order_by: [desc: n.inserted_at]
    Repo.all(query)
  end

  def future_events() do
    utc_now = DateTime.utc_now()

    query = from e in Event, where: e.date > ^utc_now

    Repo.all(query)
  end

  def create_news(title, content) do
    %News{}
    |> News.changeset(%{
      title: title,
      content: content
    })
    |> Repo.insert()
  end

  def create_event(date, label) do
    %Event{}
    |> Event.changeset(%{
      date: date,
      label: label
    })
    |> Repo.insert()
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
