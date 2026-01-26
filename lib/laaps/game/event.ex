defmodule Laaps.Game.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @separator "->"

  schema "events" do
    field :date, :utc_datetime
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
    changeset = remove_participant(changeset, name)
    current_participants = get_field(changeset, :participants, [])
    new_participants = current_participants ++ ["#{name}#{@separator}#{count}"]

    put_change(changeset, :participants, new_participants)
  end

  def remove_participant(changeset, name) do
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
    {name, count}
  end
end

# alias Laaps.Game.Event
# Event.changeset(%Event{}, %{date: ~U[2026-02-06 19:30:00Z], label: "Soirée jeux"})
