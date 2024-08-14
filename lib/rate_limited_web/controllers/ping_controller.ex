defmodule RateLimitedWeb.PingController do
  use RateLimitedWeb, :controller

  def pong(conn, _params) do
    text(conn, "ok")
  end
end
