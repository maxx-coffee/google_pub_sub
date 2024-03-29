defmodule PS.BaseConsumer do
  @callback handle_event(String.t(), any()) :: any()
  defmacro __using__(subscription: subscription) do
    quote do
      @behaviour PS.BaseConsumer
      use Broadway

      alias Broadway.Message
      alias PS.Subscriptions
      alias PS.Client

      def start_link(_opts) do
        Broadway.start_link(__MODULE__,
          name: __MODULE__,
          producer: [
            module: {BroadwayCloudPubSub.Producer, subscription: unquote(subscription)}
          ],
          processors: [
            default: []
          ],
          batchers: [
            default: [
              batch_size: 10,
              batch_timeout: 2_000
            ]
          ]
        )
      end

      def handle_message(
            _,
            %Message{
              data: data,
              metadata: %{attributes: %{"event" => event, "env" => env}}
            } = message,
            _
          ) do
        data =
          case Jason.decode(data) do
            {:error, _} -> data
            {:ok, parsed_data} -> parsed_data
          end

        handle_event(event, data, env)
        message
      end

      def handle_event(_, _), do: :ok

      defoverridable handle_event: 2

      def handle_batch(_, messages, _, _) do
        messages
      end
    end
  end
end
