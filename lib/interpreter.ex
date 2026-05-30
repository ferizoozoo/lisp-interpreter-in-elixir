defmodule Lisp.Interpreter do
  def run(src) do
    env = Lisp.Environment.new()
    tokens = Lisp.Tokenizer.tokenize(src)
    ast = Lisp.Parser.parse(tokens)
    {result, _env} = Lisp.Evaluator.eval(ast, env)
    result
  end
end
