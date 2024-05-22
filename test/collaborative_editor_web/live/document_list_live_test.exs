defmodule CollaborativeEditorWeb.DocumentListLiveTest do
  use CollaborativeEditorWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias CollaborativeEditor.Document
  alias CollaborativeEditor.Repo

  setup do
    # Seed the database with test documents
    documents = [
      %Document{title: "Document 1", content: "Initial content for Document 1"},
      %Document{title: "Document 2", content: "Initial content for Document 2"},
      %Document{title: "Document 3", content: "Initial content for Document 3"}
    ]

    for document <- documents do
      Repo.insert!(document)
    end

    # Verify that documents are inserted
    inserted_documents = Repo.all(Document)
    assert length(inserted_documents) == 3

    :ok
  end

  test "displays live documents", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/documents")
    assert has_element?(view, "li", "Document 1")
  end

  test "redirects to document edit page on click", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/documents")

    document = Repo.get_by(Document, title: "Document 1")

    view
    |> element("a", "Document 1")
    |> render_click()

    assert_redirected(view, ~p"/document/#{document.id}")
  end
end
