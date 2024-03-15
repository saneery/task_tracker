defmodule SchemaRegistry do
  @moduledoc """
  Documentation for `SchemaRegistry`.
  """

  def validate_event(data, schema_name, version \\ 1) do
    schema_name
    |> load_schema(version)
    |> validate(data)
  end

  defp load_schema(schema_name, version) do
    schema_name
    |> String.split(".")
    |> Enum.join("/")
    |> create_path(version)
    |> File.read()
    |> case do
      {:ok, schema} ->
        Jason.decode(schema)
      err ->
        err
    end
  end

  defp create_path(schema_path, version) do
    "#{__DIR__}/../schemas/" <> schema_path <> "/#{version}.json"
  end

  defp validate({:error, _} = e, _), do: e

  defp validate({:ok, schema}, data) do
    ExJsonSchema.Validator.validate(schema, data)
  end
end
