defmodule CollaborativeEditorWeb.Presence do
  use Phoenix.Presence,
    otp_app: :collaborative_editor,
    pubsub_server: CollaborativeEditor.PubSub
end
