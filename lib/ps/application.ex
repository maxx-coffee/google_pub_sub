defmodule PS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias PS.Subscription
  alias PS.MbaConsumer
  alias PS.MboConsumer

  def start(_type, _args) do
    children = [
      {PS.PeerFitConsumer, []},
      {DynamicSupervisor, strategy: :one_for_one, name: PS.DynamicSupervisor},
      PS.Subscriptions
    ]

    opts = [strategy: :one_for_one, name: PS.Supervisor]
    app = Supervisor.start_link(children, opts)

    Subscription.subscribe(MbaConsumer, "mba_sync", ["classUpdated", "classDeleted"], "feature")

    Subscription.subscribe(
      MboConsumer,
      "mbo_sync",
      ["classUpdated", "classDeleted", "clientMerged"],
      "prod"
    )

    app
  end
end
