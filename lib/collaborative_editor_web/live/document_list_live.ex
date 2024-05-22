defmodule CollaborativeEditorWeb.Live.DocumentListLive do
  use CollaborativeEditorWeb, :live_view

  alias CollaborativeEditor.Documents

  @impl true
  def mount(_params, _session, socket) do
    documents = Documents.list_documents()
    {:ok, assign(socket, documents: documents)}
  end

end
