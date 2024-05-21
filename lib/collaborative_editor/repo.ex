defmodule CollaborativeEditor.Repo do
  use Ecto.Repo,
    otp_app: :collaborative_editor,
    adapter: Ecto.Adapters.Postgres
end
