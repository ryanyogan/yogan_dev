defmodule YoganDev.Repo do
  alias YoganDev.{Article, Content}

  @type entity_types :: Article.t() | Content.t()

  @callback all(Article | Content) :: {:ok, [entity_types()]} | {:error, term}
  @callback get(Article | Content, String.t()) :: {:ok, entity_types()} | {:error, term}

  @adapter Application.get_env(:yogan_dev, __MODULE__)[:adapter]

  @spec articles :: {:ok, [Content.t()]} | {:error, term}
  def articles, do: @adapter.all(Article)

  @spec contents :: {:ok, [Content.t()]} | {:error, term}
  def contents, do: @adapter.all(Content)

  @spec get_article(String.t()) :: {:ok, Article.t()} | {:error, term}
  def get_article(id), do: @adapter.get(Article, id)
end
