defmodule YoganDev do
  @moduledoc """
  YoganDev keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defdelegate articles, to: YoganDev.Repo

  defdelegate contents, to: YoganDev.Repo

  defdelegate get_article(id), to: YoganDev.Repo
end
