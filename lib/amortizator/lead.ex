defmodule Amortizator.Lead do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Amortizator.Lead.Actions
  alias Amortizator.Lead.CustomField
  alias Amortizator.Lead.Tag

  @derive Jason.Encoder
  embedded_schema do
    field :account_id, :integer
    field :closest_task, :integer
    field :created_user_id, :integer
    embeds_many :custom_fields, CustomField
    field :date_close, :integer
    # datetime
    field :date_create, :integer
    field :deleted, :integer
    field :group_id, :integer
    # datetime
    field :last_modified, :integer
    field :linked_company_id, :integer
    field :loss_reason_id, :integer
    field :main_contact_id, :integer
    field :name, :string
    field :pipeline_id, :integer
    field :price, :string
    field :responsible_user_id, :integer
    field :status_id, :integer
    embeds_many :tags, Tag
  end

  @type t() :: %__MODULE__{}

  def changeset(%__MODULE__{} = lead, attrs) do
    lead
    |> cast(attrs, fields_to_cast())
    |> cast_embed(:custom_fields)
    |> cast_embed(:tags)
  end

  defp fields_to_cast do
    __changeset__() |> Map.drop([:custom_fields, :tags]) |> Map.keys()
  end

  defdelegate list(opts), to: Actions.List, as: :run
  defdelegate find(id), to: Actions.Find, as: :run
  defdelegate add(lead), to: Actions.Add, as: :run
  defdelegate update(lead), to: Actions.Update, as: :run
  defdelegate update(lead, attrs), to: Actions.Update, as: :run
end
