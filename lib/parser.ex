defmodule Lisp.Parser do
  def parse(tokens) do
    {expr, []} = read(tokens)
    expr
  end

  defp read([:lparen | rest]), do: read_list(rest, [])
  defp read([:rparen | _]), do: raise("unexpected )")
  defp read([tok | rest]), do: {tok, rest}

  defp read_list([:rparen | rest], acc), do: {Enum.reverse(acc), rest}

  defp read_list(tokens, acc) do
    {expr, rest} = read(tokens)
    read_list(rest, [expr | acc])
  end
end
