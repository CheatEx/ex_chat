defmodule ExChat.Guardian do
  use Guardian, otp_app: :ex_chat

  alias ExChat.Repo
  alias ExChat.User

  def subject_for_token(resource = %User{}, _claims) do
    {:ok, to_string(resource.id)}
  end
  def subject_for_token(resource) do
    {:error, "Unknown resource type"}
  end

  def resource_from_claims(claims) do
    subject = claims["sub"]
    {:ok, Repo.get(User, subject)}
  end
end
