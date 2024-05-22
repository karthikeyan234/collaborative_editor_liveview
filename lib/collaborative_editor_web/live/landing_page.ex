defmodule CollaborativeEditorWeb.LandingPage do
  use CollaborativeEditorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end


  @impl true
  def handle_event("save_name", %{"name" => name}, socket) do
    if name != "" do
      socket =
        socket
        |> assign(:name, name)
        |> push_redirect(to: ~p"/documents")

      {:noreply, socket}
    else
      socket = put_flash(socket, :error, "Name cannot be empty")
      {:noreply, socket}
    end
  end
end
