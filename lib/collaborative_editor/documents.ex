defmodule CollaborativeEditor.Documents do
  import Ecto.Query, warn: false
  alias CollaborativeEditor.Repo

  alias CollaborativeEditor.Document

  def list_documents do
    Repo.all(Document)
  end
end
