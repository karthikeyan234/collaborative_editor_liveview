defmodule CollaborativeEditorWeb.Live.DocumentLiveTest do
  use CollaborativeEditorWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias CollaborativeEditor.Document
  alias CollaborativeEditor.Repo

  setup do
    document = %Document{title: "Document 1", content: "Initial content for Document 1"}
    {:ok, document} = Repo.insert(document)

    {:ok, document: document}
  end

  test "displays document content", %{conn: conn, document: document} do
    {:ok, view, _html} = live(conn, "/document/#{document.id}/kk")

    assert has_element?(view, "textarea", document.content)
  end

  test "updates document content in real-time", %{conn: conn, document: document} do
    {:ok, view, _html} = live(conn, "/document/#{document.id}/kk")

    # Simulate user input using render_hook
    render_hook(view, "update_content", %{"content" => "Updated content"})

    # Verify that the content is updated
    assert render(view) =~ "Updated content"
  end

  test "shows currently editing users with name", %{conn: conn, document: document} do
    # Simulate user entering name and joining the document page
    {:ok, view, _html} = live(conn, "/document/#{document.id}/User1")

    # Verify that the user is listed as currently editing
    assert has_element?(view, "li", "User1")
  end

  test "tracks multiple users editing the document", %{conn: conn, document: document} do
    # Simulate multiple users joining the document page
    {:ok, view1, _html1} = live(conn, "/document/#{document.id}/User1")
    {:ok, view2, _html2} = live(conn, "/document/#{document.id}/User2")

    # Verify that both users are listed as currently editing
    assert has_element?(view1, "li", "User1")
    assert has_element?(view1, "li", "User2")
    assert has_element?(view2, "li", "User1")
    assert has_element?(view2, "li", "User2")
  end
end
