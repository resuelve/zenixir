defmodule Zendesk.User do
  @moduledoc """
  Zendesk User
  """

  alias Poison.Parser

  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json_array(json) do
    json
    |> Parser.parse(keys: :atoms)
  end

  def from_json(json) do
    json
    |> Parser.parse(keys: :atoms)
    |> elem(1)
    |> Map.get(:user)
  end
end
