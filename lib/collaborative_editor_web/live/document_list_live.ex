defmodule CollaborativeEditorWeb.Live.DocumentListLive do
  use CollaborativeEditorWeb, :live_view

  alias CollaborativeEditor.Documents

  @impl true
  def mount(params, _session, socket) do
    documents = Documents.list_documents()
    name = params["name"]
    {:ok, assign(socket, documents: documents, name: name)}
  end
end
