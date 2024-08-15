defmodule RateLimitWeb.PaymentService do
  def handle_call(msg) do
    IO.inspect(msg)

    account = Task.async(fn -> callAccount(msg) end)
    comp = Task.async(fn -> callComp(msg) end)

    res = Task.await_many([account, comp])

    IO.inspect(res)

    account_nr = Enum.at(res, 0)
    comp_state = Enum.at(res, 1)

    %{
      "account_nr" => account_nr,
      "comp" => comp_state
    }
  end

  defp callAccount(account_nr) do
    Req.get!("http://localhost:4000/api/account_lookup/#{account_nr}").body["account_nr"]
  end

  defp callComp(numb) do
    Req.get!("http://localhost:4000/api/compliance/#{numb}").body["result"]
  end
end
