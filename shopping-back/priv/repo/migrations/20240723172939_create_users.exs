defmodule Shopping.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :balance, :decimal

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:username])
  end
end
