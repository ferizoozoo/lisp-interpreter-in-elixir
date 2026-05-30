defmodule Lisp.Evaluator do
  def eval(n, env) when is_number(n), do: {n, env}
  def eval(s, env) when is_binary(s), do: {s, env}
  def eval(b, env) when is_boolean(b), do: {b, env}
  def eval(nil, env), do: {nil, env}

  def eval(atom, env) when is_atom(atom), do: {Lisp.Environment.lookup(env, atom), env}

  def eval([:quote, expr], env), do: {expr, env}

  def eval([:if, test_expr, then_expr, else_expr], env) do
    {v, _} = eval(test_expr, env)

    if v do
      eval(then_expr, env)
    else
      eval(else_expr, env)
    end
  end

  def eval([:def, name, value_expr], env) do
    {value, _} = eval(value_expr, env)
    new_env = Lisp.Environment.append(env, %{name => value})
    {value, new_env}
  end

  def eval([:lambda, params, body], env) do
    {{:closure, params, body, env}, env}
  end

  def eval([func_expr | arg_exprs], env) do
    {func, _} = eval(func_expr, env)

    args =
      Enum.map(arg_exprs, fn arg_expr ->
        {v, _} = eval(arg_expr, env)
        v
      end)

    case func do
      f when is_function(f) ->
        {apply(f, args), env}

      {:closure, params, body, closure_env} ->
        bindings = params |> Enum.zip(args) |> Map.new()
        call_env = Lisp.Environment.append(closure_env, bindings)
        {value, _} = eval(body, call_env)
        {value, env}
    end
  end
end
