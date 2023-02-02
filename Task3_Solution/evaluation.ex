defmodule Evaluation do
  @type literal() :: {:num, number()} | {:var, atom()} | {:quotient, number(), number()}
  @type expr() ::
          {:add, expr(), expr()}
          | {:sub, expr(), expr()}
          | {:mul, expr(), expr()}
          | {:div, expr(), expr()}
          | literal()
  # Any single number will be evaluated to itself. Environment does not matter in this case
  def eval({:num, n}, _environment) do n end

  # For the evaluation of a variable we have to look in the environment to find the value bound to the variable.
  # The Map.get will retrieve the value for the variable in the provided environment
  def eval({:var, v}, environment) do Map.get(environment, v) end

  # We recursively get the number and variables and pass them to their corresponding arithmetic functions
  def eval({:add, expression1, expression2}, environment) do
    add(eval(expression1, environment), eval(expression2, environment))
  end
  def eval({:sub, expression1, expression2}, environment) do
    subtract(eval(expression1, environment), eval(expression2, environment))
  end
  def eval({:mul, expression1, expression2}, environment) do
    multiply(eval(expression1, environment), eval(expression2, environment))
  end
  def eval({:div, expression1, expression2}, environment) do
    divide(eval(expression1, environment), eval(expression2, environment))
  end

   # Fractional numbers are evaluated to the lowest common denominator.
   # Are not going to contains variables. x/2 => x*1/2
   def eval({:quotient, dividend, divisor}, _environment) do
    if divisor == {:num, 0} do :undefined
    else
      gcd = Integer.gcd(dividend, divisor)
      {:quotient, dividend/gcd, divisor/gcd}
    end
  end

  #------------------------- ADD -------------------------
  # Addition with zero
  defp add({:num, number}, {:num, 0}) do {:num, number} end
  defp add({:num, 0}, {:num, number}) do {:num, number} end
  # Addition between two numbers
  defp add({:num, number1}, {:num, number2})do {:num, number1 + number2} end
  # Addition between a number and a quotient
  defp add({:num, number}, {:quotient, dividend, divisor}) do
    {:quotient, number*divisor + dividend, divisor}
  end
  defp add({:quotient, dividend, divisor}, {:num, number}) do
    {:quotient, number*divisor + dividend, divisor}
  end
  # Addition between two quotients
  defp add({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1 * divisor2 + dividend2*divisor1, divisor1*divisor2}
  end
  #------------------------- Subtract ---------------------
  # Subtraction with zero
  defp subtract({:num, number}, {:num, 0}) do {:num, number} end
  defp subtract({:num, 0}, {:num, number}) do {:num, number} end
  # Subtraction between two numbers
  defp subtract({:num, number1}, {:num, number2}) do {:num, number1 - number2} end
  # Subtraction between a number and a quotient
  defp subtract({:num, number}, {:quotient, dividend, divisor}) do
    {:quotient, number*divisor - dividend, divisor}
  end
  defp subtract({:quotient, dividend, divisor}, {:num, number}) do
    {:quotient, dividend - number*divisor, divisor}
  end
  # Subtraction between two quotients
  defp subtract({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1 * divisor2 - dividend2*divisor1, divisor1*divisor2}
  end
  #------------------------- Multiplication ---------------------
  # Multiplication with zero
  defp multiply(_number, {:num, 0}) do {:num, 0} end
  defp multiply({:num, 0}, _number) do {:num, 0} end
  # Multiplication between two numbers
  defp multiply({:num, number1}, {:num, number2}) do {:num, number1*number2} end
  # Multiplication between a number and a fraction
  defp multiply({:num, number}, {:quotient, dividend, divisor}) do
    {:quotient, number*dividend, divisor}
  end
  defp multiply({:quotient, dividend, divisor}, {:num, number}) do
    {:quotient, number*dividend, divisor}
  end
  # Multiplication between two quotients
  defp multiply({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1*dividend2, divisor1*divisor2}
  end
  #------------------------- Division ---------------------
  # Division with zero
  defp divide(_number, {:num, 0}) do :undefined end
  # Zero divided by anything
  defp divide({:num, 0}, _number) do {:num, 0} end
  # Division between two number
  defp divide({:num, number1}, {:num, number2}) do {:quotient, number1, number2} end
  #Division between a number and a quotient
  defp divide({:num, number}, {:quotient, dividend, divisor}) do
    {:quotient, number*divisor, dividend}
  end
  defp divide({:quotient, dividend, divisor}, {:num, number}) do
    {:quotient, dividend, divisor*number}
  end
  # Division between two quotients
  defp divide({:quotient, dividend1, divisor1}, {:quotient, dividend2, divisor2}) do
    {:quotient, dividend1* divisor2, dividend2*divisor1}
  end

  def test  do
    environment = %{x: 2}

    # 2x + 3 + 1/2
    expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:quot, 1, 2}}

    # 2x + 3 + 3
    # expression = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:num, 3}}

    eval(expression, environment)
  end
end
