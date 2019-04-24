defmodule Amortizator.Lead.Actions.ListFilter do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder
  embedded_schema do
    field :date_create, :map
    field :date_modify, :map
    field :tasks, :integer
    field :active, :integer
  end

  @type t() :: %__MODULE__{}

  def changeset(%__MODULE__{} = schema, attrs) do
    schema
    |> validate_date(:date_create)
    |> validate_date(:date_modify)
    |> cast(attrs, fields_to_cast())
  end

  defp validate_date(%Ecto.Changeset{} = changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset

      %{} = date ->
        ks = date |> Map.keys() |> MapSet.new()

        valid? =
          ks === MapSet.new([:from, :to]) or
            ks === MapSet.new(["from", "to"])

        if valid? do
          changeset
        else
          changeset
          |> add_error(field, "must contain :from and :to keys")
        end
    end
  end

  defp fields_to_cast do
    __changeset__() |> Map.keys()
  end
end
