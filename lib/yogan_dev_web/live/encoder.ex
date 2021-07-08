defmodule YoganDevWeb.LiveEncoder do
  alias YoganDev.Content

  def contents(items) when is_list(items) do
    {features, rest} =
      items
      |> Enum.map(&encode/1)
      |> Enum.split_with(&(&1.type == "feature"))

    rest
    |> Enum.concat([%{features: features}])
    |> List.flatten()
  end

  def encode(%Content{} = content) do
    Map.take(content, [:id, :type, :title, :content, :image, :styles])
  end
end
