defmodule Laaps.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :date, :naive_datetime
      add :label, :string
      add :participants, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
