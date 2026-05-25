defmodule Lisp.Tokenizer do
  def tokenize(src) do
    src
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.split()
    |> Enum.map(&classify/1)
  end

  defp classify("("), do: :lparen
  defp classify(")"), do: :rparen
  defp classify("#t"), do: true
  defp classify("#f"), do: false

  defp classify(tok) do
    case Integer.parse(tok) do
      {n, ""} ->
        n

      _ ->
        case Float.parse(tok) do
          {f, ""} -> f
          # symbol
          _ -> String.to_atom(tok)
        end
    end
  end
end
