defmodule CollaborativeEditor.Documents do
  import Ecto.Query, warn: false
  alias CollaborativeEditor.Repo

  alias CollaborativeEditor.Document

  def list_documents do
    Repo.all(Document)
  end

  def get_document!(id) do
    Repo.get!(Document, id)
  end

  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end
end
