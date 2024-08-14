defmodule RateLimitedWeb.Router do
  use RateLimitedWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RateLimitedWeb do
    pipe_through :api

    get "/ping", PingController, :pong
  end
end
