defmodule RateLimitWeb.PaymentServiceTest do
  use ExUnit.Case

  test "foo" do
    res = RateLimitWeb.PaymentService.handle_call("foo")
    refute res == 10
  end

  test "good test" do
    res = RateLimitWeb.PaymentService.handle_call("foo")
    assert res == %{"account_nr" => "foo", "comp" => true}
  end

  test "nice weather" do
    Req.Test.stub(RateLimitWeb.PaymentService, fn conn ->
      case conn.request_path do
        "/api/compliance/45675456" -> Req.Test.json(conn, %{"result" => true})
        "/api/account_lookup/45675456" -> Req.Test.json(conn, %{"account_nr" => 123})
      end
    end)

    assert RateLimitWeb.PaymentService.handle_call("45675456") == %{
             "account_nr" => 123,
             "comp" => true
           }
  end
end
