defmodule Lisp.Environment do
  def new() do
    %{
      # arithmetic
      :+ => &Kernel.+/2,
      :- => &Kernel.-/2,
      :* => &Kernel.*/2,
      :/ => &Kernel.div/2,
      :mod => &Kernel.rem/2,
      :negate => &Kernel.-/1,
      # comparison
      :> => &Kernel.>/2,
      :< => &Kernel.</2,
      :>= => &Kernel.>=/2,
      :<= => &Kernel.<=/2,
      :== => &Kernel.==/2,
      :!= => &Kernel.!=/2
    }
  end

  def append(env, new_bindings) do
    Map.merge(env, new_bindings)
  end

  def lookup(env, key) do
    case Map.fetch(env, key) do
      {:ok, value} -> value
      :error -> raise "undefined symbol: #{key}"
    end
  end
end
