# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CollaborativeEditor.Repo.insert!(%CollaborativeEditor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CollaborativeEditor.Repo
alias CollaborativeEditor.Document

documents = [
  %Document{title: "Document 1", content: "Initial content for Document 1"},
  %Document{title: "Document 2", content: "Initial content for Document 2"},
  %Document{title: "Document 3", content: "Initial content for Document 3"}
]

for document <- documents do
  Repo.insert!(document)
end
