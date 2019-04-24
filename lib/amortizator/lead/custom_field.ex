defmodule Amortizator.Lead.CustomField do
  use Ecto.Schema
  import Ecto.Changeset

  alias Amortizator.Lead.CustomFieldValue

  @derive Jason.Encoder
  embedded_schema do
    field :name, :string
    embeds_many :values, CustomFieldValue
  end

  @type t() :: %__MODULE__{}

  def changeset(%__MODULE__{} = schema, attrs) do
    schema
    |> cast(attrs, fields_to_cast())
    |> cast_embed(:values)
  end

  defp fields_to_cast do
    __changeset__() |> Map.drop([:values]) |> Map.keys()
  end
end
