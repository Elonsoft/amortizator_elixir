defmodule Amortizator.Lead.Actions.Find do
  alias Amortizator.{Authorizer, Lead}
  alias Amortizator.Application, as: App

  @path "/api/v2/leads?"

  def run(id) do
    body = %{id: id} |> Jason.encode!()

    (App.url() <> @path <> "id=#{id}")
    |> HTTPoison.get(headers())
    |> handle_response()
  end

  defp headers do
    [
      {"Cookie", Authorizer.auth_info()}
    ]
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    %{"_embedded" => %{"items" => [opts]}} = Jason.decode!(body)

    %Lead{}
    |> Lead.changeset(Map.update(opts, "id", nil, &to_string(&1)))
    |> Ecto.Changeset.apply_action(:insert)
  end

  defp handle_response(e), do: e
end
