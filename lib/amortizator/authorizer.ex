defmodule Amortizator.Authorizer do
  use Agent

  @auth_url "/private/api/auth.php?type=json"

  alias Amortizator.Application, as: App

  def auth_info do
    Agent.get(__MODULE__, fn info -> info end)
  end

  defp put_auth_info(info) do
    Agent.update(__MODULE__, fn _ -> info end)
  end

  def start_link(user_login: login, user_hash: hash) do
    Task.start_link(fn ->
      info = authorize(login, hash)
      put_auth_info(info)
    end)

    Agent.start_link(fn -> nil end, name: __MODULE__)
  end

  def authorize(login, hash) do
    body =
      Jason.encode!(%{
        "USER_LOGIN" => login,
        "USER_HASH" => hash,
        "type" => "json"
      })

    (App.url() <> @auth_url)
    |> HTTPoison.post(body)
    |> extract_cookies()
  end

  defp extract_cookies({:ok, %_{headers: headers, status_code: 200}}) do
    headers
    |> Enum.filter(fn
      {"Set-Cookie", value} -> String.contains?(value, "session_id")
      _ -> false
    end)
    |> case do
      [{_, cookies} | _] -> cookies |> String.split("; ") |> hd()
    end
  end
end
