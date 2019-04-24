defmodule Amortizator.Lead.Actions.ListParams do
  use Ecto.Schema
  import Ecto.Changeset

  alias Amortizator.Lead.Actions.ListFilter

  @derive Jason.Encoder
  embedded_schema do
    field :limit_rows, :integer
    field :limit_offset, :integer
    field :query, :string
    field :responsible_user_id, {:array, :integer}
    field :with, :string
    field :status, :integer
    embeds_one :filter, ListFilter
  end

  @type t() :: %__MODULE__{}

  def changeset(%__MODULE__{} = schema, attrs) do
    schema
    |> cast(attrs, fields_to_cast())
    |> cast_embed(:filter)
  end

  defp fields_to_cast do
    __changeset__() |> Map.drop([:filter, :id]) |> Map.keys()
  end

  def encode(%__MODULE__{} = params) do
    params
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn
      {_, nil}, acc -> acc
      {:__struct__, _}, acc -> acc
      {k, v}, acc -> acc |> Map.put(k, v)
    end)
    |> URI.encode_query()
  end
end
