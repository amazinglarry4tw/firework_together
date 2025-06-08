defmodule FireworkTogether.Repo do
  use Ecto.Repo,
    otp_app: :firework_together,
    adapter: Ecto.Adapters.Postgres
end
