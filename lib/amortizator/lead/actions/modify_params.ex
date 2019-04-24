defmodule Amortizator.Lead.Actions.ModifyParams do
  @moduledoc """
  The module provides api for leads.

  # Struct keys

  :id -- int -- id сделки, в которую будут вноситься изменения
  :name -- string -- Название сделки
  :created_at -- timestamp -- Дата создания текущей сделки
  :updated_at -- timestamp -- Дата изменения текущей сделки
  :status_id -- int -- Статус сделки (id этапа продаж см. Воронки и этапы 
    продаж) Чтобы перенести сделку в другую воронку, необходимо установить ей
    статус из нужной воронки
  :pipteline_id -- ID воронки. Указывается в том случае, если выбраны статусы 
     id 142 или 143, т.к. эти статусы не уникальны и обязательны для всех 
     цифровых воронок.
  :responsible_user_id -- ID ответственного пользователя
  :sale -- Бюджет сделки
  :tags -- list of strings or string -- Если вы хотите задать новые теги,
    перечислите их внутри строковой переменной через запятую. В случае если
    вам необходимо прикрепить существующие теги, передавайте массив числовых
    значений id существующих тегов.
  :contacts_id -- list of int -- Уникальный идентификатор контакта, для связи с сделкой.
    Можно передавать несколько id, перечисляя их в массиве через запятую.
    (Не более 40 контактов у 1 сделки)
  :company_id -- Уникальный идентификатор компании, для связи с сделкой
  :custom_fields -- CustomFields.t -- Внутри данного массива находится 
    содержимое каждого заполненного дополнительного поля

  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Amortizator.Lead.{CustomField, Tag}

  @derive Jason.Encoder
  embedded_schema do
    field :name, :string
    field :created_at, :integer
    field :updated_at, :integer
    field :status_id, :integer
    field :pipteline_id, :integer
    field :responsible_user_id, :integer
    field :sale, :integer
    embeds_many :tags, Tag
    # {:array, :integer}
    field :contacts_id, :string
    field :company_id, :integer
    embeds_many :custom_fields, CustomField
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

  def encode(%__MODULE__{} = params) do
    params
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn
      {_, nil}, acc -> acc
      {:__struct__, _}, acc -> acc
      {k, v}, acc -> acc |> Map.put(k, v)
    end)
  end
end

defimpl Jason.Encoder, for: [Amortizator.Lead.Actions.ModifyParams] do
  def encode(params, _) do
    params
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn
      {_, nil}, acc -> acc
      {:__struct__, _}, acc -> acc
      {k, v}, acc -> acc |> Map.put(k, v)
    end)
    |> Jason.encode!()
  end
end
