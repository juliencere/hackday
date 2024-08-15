defmodule RateLimitWeb.PaymentListener do
  use GenServer
  alias RateLimtedWeb.XmlParser

  def start_link(_) do
    IO.inspect("start listeners")
    {:ok, pid} = GenServer.start_link(__MODULE__, %{})
  end

  def init(params) do
    IO.inspect("start init")

    {:ok, conn} = Stompex.connect("localhost", 61616, "artemis", "artemis")

    Stompex.send_to_caller(conn, true)
    Stompex.subscribe(conn, "payment")

    {:ok, %{stompex: conn}}
  end

  def handle_info({:stompex, "payment", frame}, %{stompex: conn} = state) do
    IO.inspect(frame.body)
    IO.inspect(state)

    res = XmlParser.parse_xml(frame.body)
      |> to_string
      |> RateLimitWeb.PaymentService.handle_call

    IO.inspect("response")
    IO.inspect(res)

    {:noreply, state}
  end
end
