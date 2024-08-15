defmodule RateLimitedWeb.Router do
  use RateLimitedWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RateLimitedWeb do
    pipe_through :api

    get "/ping/:numb", PingController, :pong
    get "/payment", PingController, :send
    get "/account_lookup/:account_nr", PingController, :account_lookup
    get "/compliance/:account_nr", PingController, :compliance
    get "/post_xml", PingController, :post_xml
  end
end
