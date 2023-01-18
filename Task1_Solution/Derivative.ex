defmodule Deriv do
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() ::
          literal() | {:add, expr(), expr()} | {:mul, expr(), expr()} | {:exp, expr(), literal()}

  def test_simple() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
    d = deriv(e, :x)
    IO.write("Expression: #{p_print(e)}\n")
    IO.write("Derivative of expression: #{p_print(d)}\n")
    IO.write("Simplified: #{p_print(simplify(d))}\n")
    :ok
  end

  def test_pow() do
    e = {:add, {:exp, {:var, :x}, {:num, -3}}, {:num, 4}}
    d = deriv(e, :x)
    IO.write("Expression: #{p_print(e)}\n")
    IO.write("Derivative of expression: #{p_print(d)}\n")
    IO.write("Simplified: #{p_print(simplify(d))}\n")
    :ok
  end

  def test_long_expr() do
    e =
      {:add,
       {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}, {:mul, {:num, 3}, {:var, :x}}},
       {:num, 5}}

    d = deriv(e, :x)
    IO.write("Expression: #{p_print(e)}\n")
    IO.write("Derivative of expression: #{p_print(d)}\n")
    IO.write("Simplified: #{p_print(simplify(d))}\n")
    :ok
  end

  ###### Our derivatives rules #######

  # derivative of a constant
  def deriv({:num, _}, _) do {:num, 0} end

  # derivative of x to the power of one
  def deriv({:var, v}, v) do {:num, 1} end

  # derivative of another variable than x
  def deriv({:var, _}, _) do {:num, 0} end

  # d/dx(f+g) = f'(x) + g'(x)
  def deriv({:add, e1, e2}, v) do {:add, deriv(e1, v), deriv(e2, v)} end

  # d/dx(f*g) = f'(x)g(x) + f(x)g'(x)
  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}}
  end

  # d/dx(u(x)^n) = n(u(x))^(n-1)*u'(x), where n is a real number
  def deriv({:exp, u, {:num, n}}, v) do
    {:mul, {:mul, {:num, n}, {:exp, u, {:num, n - 1}}}, deriv(u, v)}
  end

  ###### --------------------- #######

  #simplifies the expression by removing zeros and ones etc.
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end

  def simplify_add(e1, {:num, 0}) do e1 end

  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end

  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end

  def simplify_mul(_, {:num, 0}) do {:num, 0} end

  def simplify_mul({:num, 1}, e2) do e2 end

  def simplify_mul(e1, {:num, 1}) do e1 end

  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end

  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end

  def simplify_exp(e1, {:num, 1}) do e1 end

  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end

  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  # p_print functions converts from our syntax tree into strings for ease of reading
  def p_print({:num, n}) do "#{n}" end

  def p_print({:var, v}) do "#{v}" end

  def p_print({:add, e1, e2}) do "#{p_print(e1)} + #{p_print(e2)}" end

  def p_print({:mul, e1, e2}) do "(#{p_print(e1)}*#{p_print(e2)})" end

  def p_print({:exp, e1, e2}) do "(#{p_print(e1)})^(#{p_print(e2)})" end
end
