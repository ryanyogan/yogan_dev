defmodule Services.Airtable do
  @moduledoc """
  Service layer that exposes `Airtable.com`'s API
  """

  @spec all(String.t()) :: {:ok, term} | {:error, non_neg_integer()}
  def all(table), do: do_get("/#{table}")

  @spec get(String.t(), String.t()) :: {:ok, term} | {:error, non_neg_integer()}
  def get(table, record_id), do: do_get("/#{table}/#{record_id}")

  defp client do
    middleware = [
      {Tesla.Middleware.BaseUrl, api_url() <> base_id()},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Logger,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> api_key()}]}
    ]

    Tesla.client(middleware)
  end

  defp do_get(path) do
    client()
    |> Tesla.get(path)
    |> case do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status}} ->
        {:error, status}

      other ->
        other
    end
  end

  defp api_url, do: Application.get_env(:yogan_dev, __MODULE__)[:api_url]
  defp api_key, do: Application.get_env(:yogan_dev, __MODULE__)[:api_key]
  defp base_id, do: Application.get_env(:yogan_dev, __MODULE__)[:base_id]
end
