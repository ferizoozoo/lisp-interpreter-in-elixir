defmodule LispInterpreterTest do
  use ExUnit.Case

  defp run(src), do: Lisp.Interpreter.run(src)

  describe "arithmetic" do
    test "addition" do
      assert run("(+ 1 2)") == 3
    end

    test "subtraction" do
      assert run("(- 10 3)") == 7
    end

    test "multiplication" do
      assert run("(* 4 5)") == 20
    end

    test "division" do
      assert run("(/ 10 2)") == 5
    end

    test "modulo" do
      assert run("(mod 10 3)") == 1
    end

    test "negate" do
      assert run("(negate 5)") == -5
    end
  end

  describe "comparisons" do
    test "greater than true" do
      assert run("(> 5 3)") == true
    end

    test "greater than false" do
      assert run("(> 1 3)") == false
    end

    test "less than" do
      assert run("(< 1 3)") == true
    end

    test "equal" do
      assert run("(== 2 2)") == true
    end

    test "not equal" do
      assert run("(!= 2 3)") == true
    end
  end

  describe "literals" do
    test "integer" do
      assert run("42") == 42
    end

    test "float" do
      assert run("3.14") == 3.14
    end

    test "boolean true" do
      assert run("#t") == true
    end

    test "boolean false" do
      assert run("#f") == false
    end
  end

  describe "def" do
    test "defines and returns value" do
      assert run("(def x 10)") == 10
    end

    test "defines and uses in same expression via lambda" do
      assert run("((lambda (x) (* x x)) 5)") == 25
    end
  end

  describe "if" do
    test "true branch" do
      assert run("(if #t 1 2)") == 1
    end

    test "false branch" do
      assert run("(if #f 1 2)") == 2
    end

    test "condition from comparison" do
      assert run("(if (> 5 3) 10 20)") == 10
    end
  end

  describe "quote" do
    test "returns list unevaluated" do
      assert run("(quote (1 2 3))") == [1, 2, 3]
    end

    test "returns atom unevaluated" do
      assert run("(quote x)") == :x
    end
  end

  describe "lambda" do
    test "identity function" do
      assert run("((lambda (x) x) 42)") == 42
    end

    test "multi-param function" do
      assert run("((lambda (a b) (+ a b)) 3 4)") == 7
    end

    test "closure captures environment" do
      assert run("((lambda (x) (* x x)) 6)") == 36
    end
  end

  describe "nested expressions" do
    test "nested arithmetic" do
      assert run("(+ (* 2 3) (- 10 4))") == 12
    end

    test "nested if" do
      assert run("(if (> 5 3) (+ 1 1) (+ 2 2))") == 2
    end
  end

  describe "errors" do
    test "undefined symbol raises" do
      assert_raise RuntimeError, ~r/undefined symbol/, fn ->
        run("(+ x 1)")
      end
    end

    test "unexpected closing paren raises" do
      assert_raise RuntimeError, fn ->
        run(")")
      end
    end
  end
end
