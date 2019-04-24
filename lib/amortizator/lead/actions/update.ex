defmodule Amortizator.Lead.Actions.Update do
  @moduledoc false
  require Logger

  alias Amortizator.Application, as: App
  alias Amortizator.{Authorizer, Lead}
  alias Amortizator.Lead.Actions.ModifyParams, as: Params

  @path "/api/v2/leads"

  def run(%Params{} = lead) do
    body = %{update: [lead]} |> Jason.encode!()

    Logger.info("Request body: #{body}")

    (App.url() <> @path)
    |> HTTPoison.post(body, headers())
    |> handle_response()
  end

  def run(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.apply_action(:update)
    |> case do
      {:ok, lead} -> run(lead)
      e -> e
    end
  end

  def run(%{} = attrs) do
    %Params{}
    |> Lead.changeset(attrs)
    |> run()
  end

  def run(%Lead{} = lead, attrs) do
    lead
    |> Lead.changeset(attrs)
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
