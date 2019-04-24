defmodule Amortizator.Lead.CustomFieldValue do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder
  embedded_schema do
    # field :id, :integer
    # Значение дополнительного поля.
    field :value, :string

    # Тип изменяемого элемента дополнительного поля типа "адрес".
    # Внимание, все типы, которые не были переданы, будут стёрты.
    field :subtype, :string
  end

  @type t() :: %__MODULE__{}

  def changeset(%__MODULE__{} = schema, attrs) do
    schema
    |> cast(attrs, fields_to_cast())
  end

  defp fields_to_cast do
    __changeset__() |> Map.keys()
  end
end
