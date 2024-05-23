defmodule CollaborativeEditorWeb.Live.DocumentLive do
  use CollaborativeEditorWeb, :live_view

  alias CollaborativeEditor.Documents
  alias CollaborativeEditorWeb.Presence

  @moduledoc """
  Handles the real-time collaborative document editing.
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "name" => name}, _url, socket) do
    if connected?(socket), do: track_user_presence(socket, id, name)

    document = Documents.get_document!(id)
    {:noreply, assign(socket, document: document, name: name, users: %{})}
  end

  @impl true
  def handle_event("update_content", %{"content" => content}, socket) do
    document = socket.assigns.document

    # Update the document content in the database
    case Documents.update_document(document, %{content: content}) do
      {:ok, updated_document} ->
        # Update the document content in the socket
        socket = assign(socket, document: updated_document)

        # Broadcast the update to all clients subscribed to this document
        CollaborativeEditorWeb.Endpoint.broadcast("document:#{document.id}", "content_update", %{
          content: content
        })

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info(%{event: "content_update", payload: %{content: content}}, socket) do
    {:noreply, assign(socket, document: %{socket.assigns.document | content: content})}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _diff}, socket) do
    users = Presence.list("document:#{socket.assigns.document.id}")
    {:noreply, assign(socket, users: users)}
  end

  defp track_user_presence(socket, document_id, name) do
    CollaborativeEditorWeb.Endpoint.subscribe("document:#{document_id}")

    Presence.track(self(), "document:#{document_id}", socket.id, %{
      user: name
    })
  end
end
