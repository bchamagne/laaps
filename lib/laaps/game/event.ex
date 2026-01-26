defmodule Laaps.Game.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @separator "->"

  schema "events" do
    field :date, :naive_datetime
    field :label, :string
    field :participants, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:date, :label, :participants])
    |> validate_required([:date, :label])
  end

  def add_participant(changeset, name, count) do
    name = sanitize(name)
    changeset = remove_participant(changeset, name)
    current_participants = get_field(changeset, :participants, [])
    new_participants = current_participants ++ ["#{name}#{@separator}#{count}"]

    put_change(changeset, :participants, new_participants)
  end

  def remove_participant(changeset, name) do
    name = sanitize(name)
    current_participants = get_field(changeset, :participants, [])

    new_participants =
      Enum.filter(current_participants, fn p ->
        not String.starts_with?(p, name <> @separator)
      end)

    put_change(changeset, :participants, new_participants)
  end

  def decode_participant(str) do
    [name, count] = String.split(str, @separator)
    {count, ""} = Integer.parse(count)

    {title_case(name), count}
  end

  defp sanitize(string) do
    string |> String.downcase() |> String.trim() |> String.replace(~r/\s+/, " ")
  end

  defp title_case(string) do
    string
    |> String.downcase()
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end

# alias Laaps.Game.Event
# Event.changeset(%Event{}, %{date: ~U[2026-02-06 19:30:00Z], label: "Soirée jeux"})
