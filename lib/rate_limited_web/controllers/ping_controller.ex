defmodule RateLimitedWeb.PingController do
  use RateLimitedWeb, :controller

  def pong(conn, %{"numb" => numb}) do
    account = Task.async(fn -> callAccount(numb) end)
    comp = Task.async(fn -> callComp(numb) end)

    res = Task.await_many([account, comp])

    IO.inspect(res)

    account_nr = Enum.at(res, 0)
    comp_state = Enum.at(res, 1)

    result = %{
      "account_nr" => account_nr,
      "comp" => comp_state
    }

    json(conn, result)
    # text(conn, "#{account_lookup_result} #{complienace_result}")
  end

  def send(conn, param) do
    send_mq("hello")
    text(conn, :ok)
  end

  defp send_mq(msg) do
    mq = setup_mq()
    res = Stompex.send(mq, "payment", msg)

    IO.inspect(res)

    Stompex.disconnect(mq)
  end

  defp setup_mq() do
    {:ok, conn} = Stompex.connect("localhost", 61616, "artemis", "artemis")
    conn
  end

  def receive(msg) do
  end

  def account_lookup(conn, %{"account_nr" => account_nr}) do
    IO.inspect(account_nr)

    json(conn, %{"account_nr" => account_nr})
  end

  def compliance(conn, %{"account_nr" => account_nr}) do
    sample_json = %{"result" => true}

    json(conn, sample_json)
  end

  defp callAccount(account_nr) do
    Req.get!("http://localhost:4000/api/account_lookup/1234").body["account_nr"]
  end

  defp callComp(numb) do
    Req.get!("http://localhost:4000/api/compliance/1234").body["result"]
  end

  def post_xml(conn, _params) do
    xml_file = File.read!("priv/docs/pacs.008.001.08.xml")

    send_mq(xml_file)

    text(conn, xml_file)
  end

    def post_external_xml(conn, params) do
    {:ok, body, conn} = read_body(conn)
    IO.inspect(body)
    send_mq(body)

    text(conn, body)
  end
end
