defmodule ReponetWeb.AuthController do
  @moduledoc """
  Handles OAuth authentication callbacks.
  """
  use ReponetWeb, :controller

  plug Ueberauth

  alias Reponet.Accounts
  alias ReponetWeb.UserAuth

  @doc """
  Handles the OAuth callback from GitHub.

  On success, creates or finds the user and logs them in.
  On failure, redirects to login with an error message.
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_attrs = %{
      email: auth.info.email,
      github_id: auth.uid,
      username: auth.info.nickname,
      avatar_url: auth.info.image,
      provider: "github"
    }

    case Accounts.find_or_create_github_user(user_attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome, #{user.username || user.email}!")
        |> UserAuth.log_in_user(user)

      {:error, :email_already_taken} ->
        conn
        |> put_flash(:error, "An account with this email already exists. Please log in with your password.")
        |> redirect(to: ~p"/users/log_in")

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end)

        conn
        |> put_flash(:error, "Could not authenticate: #{inspect(errors)}")
        |> redirect(to: ~p"/users/log_in")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    message = failure.errors |> Enum.map(& &1.message) |> Enum.join(", ")

    conn
    |> put_flash(:error, "Authentication failed: #{message}")
    |> redirect(to: ~p"/users/log_in")
  end
end
