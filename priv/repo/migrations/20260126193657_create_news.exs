defmodule Laaps.Repo.Migrations.CreateNews do
  use Ecto.Migration

  def change do
    create table(:news) do
      add :title, :string
      add :content, :string

      timestamps(type: :utc_datetime)
    end
  end
end
