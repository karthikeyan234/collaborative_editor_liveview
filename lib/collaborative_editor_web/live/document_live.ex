defmodule CollaborativeEditorWeb.Live.DocumentLive do
  use CollaborativeEditorWeb, :live_view
  alias CollaborativeEditor.Documents
  alias CollaborativeEditorWeb.Presence

  @impl true
  def mount(params, _session, socket) do
    name = params["name"] || "Anonymous"
    IO.inspect(name, label: "Session Data: name")

    if connected?(socket), do: track_user_presence(socket, params["id"], name)

    document = Documents.get_document!(params["id"])

    # Fetch the current presence list immediately after mounting
    users = Presence.list("document:#{params["id"]}")
    IO.inspect(users, label: "Initial Presence Users")

    {:ok, assign(socket, document: document, users: users, name: name)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    IO.inspect(diff, label: "Presence Diff")
    users = Presence.list("document:#{socket.assigns.document.id}")
    IO.inspect(users, label: "Presence Users")
    {:noreply, assign(socket, users: users)}
  end

  @impl true
  def handle_info(%{event: "content_update", payload: %{content: content}}, socket) do
    {:noreply, assign(socket, document: %{socket.assigns.document | content: content})}
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

  defp track_user_presence(socket, document_id, name) do
    CollaborativeEditorWeb.Endpoint.subscribe("document:#{document_id}")

    Presence.track(self(), "document:#{document_id}", socket.id, %{
      user: name
    })
  end
end
