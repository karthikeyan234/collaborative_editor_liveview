defmodule CollaborativeEditorWeb.LandingPageTest do
  use CollaborativeEditorWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  @doc """
  Test to ensure the landing page renders correctly.
  """
  test "renders landing page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert has_element?(view, "input[name=name]")
    assert has_element?(view, "button[type=submit]", "Submit")
  end

  @doc """
  Test to ensure the name is saved and user is redirected.
  """
  test "redirects to document list page on valid name submit", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> form("#user-form", name: "Karthikeyan")
    |> render_submit()

    assert_redirect(view, ~p"/documents?name=Karthikeyan")
  end

  @doc """
  Test to ensure error is shown on empty name submit.
  """
  test "shows error on empty name submit", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> form("#user-form", name: "")
    |> render_submit()

    assert render(view) =~ "Name cannot be empty"
    assert has_element?(view, ".alert-error", "Name cannot be empty")
  end
end
