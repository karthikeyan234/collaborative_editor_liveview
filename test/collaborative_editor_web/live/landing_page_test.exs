defmodule CollaborativeEditorWeb.LandingPageTest do
  use CollaborativeEditorWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders landing page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "input[name=name]")
    assert has_element?(view, "button[type=submit]", "Submit")
  end

  test "redirects to document list on valid name submit", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> form("#user-form", name: "KK")
    |> render_submit()

    assert_redirect(view, ~p"/documents")
  end

  test "shows error on empty name submit", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> form("#user-form", name: "")
    |> render_submit()

    assert view |> has_element?(".alert-error", "Name cannot be empty")
  end
end
