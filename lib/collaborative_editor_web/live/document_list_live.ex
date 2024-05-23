defmodule CollaborativeEditorWeb.Live.DocumentListLive do
  use CollaborativeEditorWeb, :live_view

  alias CollaborativeEditor.Documents

  @moduledoc """
  Handles the display of the document list page where users can see and select documents to edit.
  """

  @impl true
  def mount(_params, _session, socket) do
    documents = Documents.list_documents()
    {:ok, assign(socket, documents: documents)}
  end

  @impl true
  def handle_params(%{"name" => name}, _url, socket) do
    # Store the user's name in the socket assigns
    {:noreply, assign(socket, :name, name)}
  end
end
