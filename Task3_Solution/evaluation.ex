defmodule Evaluation do
  @type literal() :: {:num, number()} | {:var, atom()} | {:quotient, number(), number()}
  @type expr() ::
          {:add, expr(), expr()}
          | {:sub, expr(), expr()}
          | {:mul, expr(), expr()}
          | {:div, expr(), expr()}
          | literal()
  # Any single number will be evaluated to itself. Environment does not matter in this case
  def eval({:num, number}, _environment) do number end

  # For the evaluation of a variable we have to look in the environment to find the value bound to the variable.
  # The Map.get will retrieve the value for the variable in the provided environment
  def eval({:var, v}, environment) do Map.get(environment, v) end

  # If either of the expression being passed to the recursive calls are undefined, the function should
  # immediately return undefined without making any further calculations.
  # To do this we add a conditional check before each recursive cal to eval.

  # We recursively get the number and variables and pass them to their corresponding arithmetic functions
  def eval({:add, expression1, expression2}, environment) do
    left = eval(expression1, environment)
    right = eval(expression2, environment)
    if left == :undefined || right == :undefined do
      :undefined
    else
      add(left, right)
    end
  end
  def eval({:sub, expression1, expression2}, environment) do
    left = eval(expression1, environment)
    right = eval(expression2, environment)
    if left == :undefined || right == :undefined do
      :undefined
    else
      subtract(left, right)
    end
  end
  def eval({:mul, expression1, expression2}, environment) do
    left = eval(expression1, environment)
    right = eval(expression2, environment)
    if left == :undefined || right == :undefined do
      :undefined
    else
      multiply(left, right)
    end
  end
  def eval({:div, expression1, expression2}, environment) do
    divisor = eval(expression2, environment)
    if divisor == 0 do
      :undefined
    else
      numerator = eval(expression1, environment)
      if numerator == :undefined do
        :undefined
      else
        divide(numerator, divisor)
      end
    end
  end
   # Fractional numbers are evaluated to the lowest common denominator.
   # Are not going to contains variables. x/2 => x*1/2
   def eval({:quotient, dividend, divisor}, _environment) do
    if divisor == 0 do :undefined
    else
      gcd = Integer.gcd(dividend, divisor)
      divid = dividend/gcd
      divi = divisor/gcd
      {:quotient, divid, divi}
    end
  end
    #------------------------- ADD -------------------------
   # Addition between two quotients
   defp add({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1 * divisor2 + dividend2*divisor1, divisor1*divisor2}
  end
  # Addition between a number and a quotient
  defp add(number, {:quotient, dividend, divisor}) do
    {:quotient, number*divisor + dividend, divisor}
  end
  defp add({:quotient, dividend, divisor}, number) do
    {:quotient, number*divisor + dividend, divisor}
  end
   # Addition between two numbers
   defp add(number1, number2) do
    number1 + number2
end
  #------------------------- Subtract ---------------------
  # Subtraction between two quotients
  defp subtract({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1 * divisor2 - dividend2*divisor1, divisor1*divisor2}
  end
  # Subtraction between a number and a quotient
  defp subtract(number, {:quotient, dividend, divisor}) do
    {:quotient, number*divisor - dividend, divisor}
  end
  defp subtract({:quotient, dividend, divisor}, number) do
    {:quotient, dividend - number*divisor, divisor}
  end
  # Subtraction between two numbers
  defp subtract({:num, number1}, {:num, number2}) do {:num, number1 - number2} end
  #------------------------- Multiplication ---------------------
  # Multiplication between two quotients
  defp multiply({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1*dividend2, divisor1*divisor2}
  end
  # Multiplication between a number and a fraction
  defp multiply(number, {:quotient, dividend, divisor}) do
    {:quotient, number*dividend, divisor}
  end
  defp multiply({:quotient, dividend, divisor}, number) do
    {:quotient, number*dividend, divisor}
  end
  # Multiplication between two numbers
  defp multiply(number1, number2) do number1*number2 end
  #------------------------- Division ---------------------
  # Division between two quotients
  defp divide({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1* divisor2, dividend2*divisor1}
  end
  #Division between a number and a quotient
  defp divide(number, {:quotient, dividend, divisor}) do
    {:quotient, number*divisor, dividend}
  end
  defp divide({:quotient, dividend, divisor}, number) do
    {:quotient, dividend, divisor*number}
  end
  # Division between two number
  defp divide(number1, number2) do {:quotient, number1, number2} end
  #------------------------- Pretty Printer ---------------------
  def pretty_print(expression) do
    case expression do
      {:num, number} -> "#{number}"
      {:var, variable} -> "#{variable}"
      {:quotient, numerator, denominator} -> "#{numerator}/#{denominator}"
      {:add, expression1, expression2} -> "#{pretty_print(expression1)} + #{pretty_print(expression2)}"
      {:sub, expression1, expression2} -> "#{pretty_print(expression1)} - #{pretty_print(expression2)}"
      {:mul, expression1, expression2} -> "#{pretty_print(expression1)}*#{pretty_print(expression2)}"
      {:div, expression1, expression2} -> "(#{pretty_print(expression1)}) / (#{pretty_print(expression2)})"
      _ -> "Error: invalid expression"
    end
  end
  #------------------------- Testing ---------------------
  def test1  do
    environment = %{x: 2}

    # 2x + 3 + 1/2
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:quotient, 1, 2}}

    # 2x + 3 - 1/2
    # expression = {:sub, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:quotient, 1, 2}}

    # 2x + 3 + 3
    # expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:num, 3}}

    # 2/0 + 3 + 3
    # expression = {:add, {:add, {:div, {:num, 2}, {:num, 0}}, {:num, 3}}, {:num, 3}}

    eval(expression, environment)
  end

  def test2  do
    env = %{a: 1, b: 2, c: 3, d: 4}
    expr = {:div, {:add, {:add, {:mul, {:num, 2}, {:var, :a}}, {:num, 3}}, {:quotient, 6, 8}}, {:num, 4}}
    expr1 = {:mul, {:quotient, 5, 2}, {:quotient, 4, 3}}
    IO.write("Expression: #{pretty_print(expr)}\n")
    IO.write("Expected: 23/16\n")
    IO.write("Result: ")
    eval(expr, env)
  end
end
