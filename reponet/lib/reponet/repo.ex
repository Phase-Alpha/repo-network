defmodule Reponet.Repo do
  use Ecto.Repo,
    otp_app: :reponet,
    adapter: Ecto.Adapters.Postgres
end
