defmodule Amortizator.Lead.Tag do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: false}

  embedded_schema do
    field :entity_type, :string
    field :name, :string
  end

  @type t() :: %__MODULE__{}

  def changeset(%__MODULE__{} = lead, attrs) do
    lead
    |> cast(attrs, fields_to_cast())
  end

  defp fields_to_cast do
    __changeset__() |> Map.drop([:custom_fields]) |> Map.keys()
  end
end
