defmodule RateLimitedWeb.ErrorJSONTest do
  use RateLimitedWeb.ConnCase, async: true

  test "renders 404" do
    assert RateLimitedWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert RateLimitedWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
