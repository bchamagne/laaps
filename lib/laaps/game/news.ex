defmodule Laaps.Game.News do
  use Ecto.Schema
  import Ecto.Changeset

  schema "news" do
    field :title, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(news, attrs) do
    news
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
