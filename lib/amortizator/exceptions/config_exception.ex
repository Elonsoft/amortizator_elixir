defmodule Amortizator.Exceptions.ConfigException do
  defexception [:message]

  def exception(:config) do
    %__MODULE__{message: "Config for :amortizator not found."}
  end

  def exception(field) do
    %__MODULE__{
      message:
        "Config field :#{field} was not supplied. " <>
          """
          Make sure you didn't misspelled any field in config, and, in case you
          supply these values with System.get_env/1, the environment variable
          is properly set.
          """
    }
  end
end
