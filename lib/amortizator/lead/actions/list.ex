defmodule Amortizator.Lead.Actions.List do
  alias Amortizator.{Authorizer, Lead}
  alias Amortizator.Application, as: App
  alias Amortizator.Lead.Actions.ListParams, as: Params

  @path "/api/v2/leads?"

  def run(%Params{} = params) do
    (App.url() <> @path <> Params.encode(params))
    |> HTTPoison.get(headers())
    |> handle_response()
  end

  def run(%{} = opts) do
    %Params{}
    |> Params.changeset(opts)
    |> Ecto.Changeset.apply_action(:insert)
    |> case do
      {:ok, params} -> run(params)
      e -> e
    end
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
    %{"response" => %{"leads" => items}} = Jason.decode!(body)

    items
    |> Enum.map(fn res ->
      %Lead{}
      |> Lead.changeset(res)
      |> Ecto.Changeset.apply_action(:insert)
      |> case do
        {:ok, res} -> res
        e -> e
      end
    end)
  end

  defp handle_response(e), do: e
end
