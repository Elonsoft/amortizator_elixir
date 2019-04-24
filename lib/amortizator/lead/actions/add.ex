defmodule Amortizator.Lead.Actions.Add do
  @moduledoc false
  require Logger

  alias Amortizator.Application, as: App
  alias Amortizator.{Authorizer, Lead}
  alias Amortizator.Lead.Actions.ModifyParams, as: Params

  @path "/api/v2/leads"

  # Lead.add(%{name: "testtest2", account_id: 26512186, responsible_user_id: 3419269, status_id: 26513722, pipeline_id: 1746631, main_contact_id: 11421643})

  def run(%Params{} = lead) do
    body = %{add: [lead]} |> Jason.encode!()

    Logger.info("Request body: #{body}")

    (App.url() <> @path)
    |> HTTPoison.post(body, headers())
    |> handle_response()
  end

  def run(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.apply_action(:insert)
    |> case do
      {:ok, lead} -> run(lead)
      e -> e
    end
  end

  def run(%{} = attrs) do
    %Params{}
    |> Params.changeset(attrs)
    |> run()
  end

  def run!(params) do
    case run(params) do
      {:ok, res} -> res
    end
  end

  defp headers do
    [
      {"Cookie", Authorizer.auth_info()}
    ]
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    %{"_embedded" => %{"items" => [%{"id" => id}]}} = Jason.decode!(body)
    Lead.find(id)
  end

  defp handle_response(e), do: e
end
