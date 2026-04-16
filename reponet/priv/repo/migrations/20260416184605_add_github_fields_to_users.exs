defmodule Reponet.Repo.Migrations.AddGithubFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :github_id, :string
      add :username, :string
      add :avatar_url, :string
      add :provider, :string, default: "local"
    end

    create unique_index(:users, [:github_id])
    create unique_index(:users, [:username])
  end
end
