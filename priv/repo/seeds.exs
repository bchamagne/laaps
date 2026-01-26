# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Laaps.Repo.insert!(%Laaps.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Laaps.Repo
alias Laaps.Game.Event
alias Laaps.Game.News

Repo.insert!(%Event{
  date: ~N[2026-03-06 20:30:00],
  label: "Soirée Jeux"
})

Repo.insert!(%Event{
  date: ~N[2026-04-03 20:30:00],
  label: "Soirée Jeux"
})

Repo.insert!(%Event{
  date: ~N[2026-04-24 20:30:00],
  label: "Soirée Jeux"
})

Repo.insert!(%Event{
  date: ~N[2026-05-29 20:30:00],
  label: "Soirée Jeux"
})

Repo.insert!(%Event{
  date: ~N[2026-06-12 20:30:00],
  label: "Soirée Jeux"
})

Repo.insert!(%Event{
  date: ~N[2026-06-26 20:30:00],
  label: "Soirée Jeux"
})
