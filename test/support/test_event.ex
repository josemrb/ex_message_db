defmodule ExMessageDB.TestEvent do
  @moduledoc """
  Test Event embedded schema.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :amount, :integer
    field :enabled, :boolean, default: true
    field :since, :naive_datetime_usec
  end

  def changeset(%__MODULE__{} = schema, params \\ %{}) do
    schema
    |> cast(params, [:name, :amount, :enabled, :since])
    |> validate_required([:name, :amount])
  end

  def create(params \\ %{}) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:create)
  end

  def create!(params \\ %{}) do
    case create(params) do
      {:ok, struct} ->
        struct

      {:error, changeset} ->
        raise Ecto.InvalidChangesetError, action: changeset.action, changeset: changeset
    end
  end
end
