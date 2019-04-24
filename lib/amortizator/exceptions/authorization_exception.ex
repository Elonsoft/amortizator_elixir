defmodule Amortizator.Exceptions.AuthorizationException do
  defexception [:message]

  def exception(details) do
    %__MODULE__{message: "Couldn't authorize: #{details}"}
  end
end
