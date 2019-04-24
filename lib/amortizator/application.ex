defmodule Amortizator.Application do
  @moduledoc false
  use Application

  alias Amortizator.Authorizer
  alias Amortizator.Exceptions.ConfigException

  @config Application.get_all_env(:amortizator) || raise(ConfigException, :config)
  @user_login @config[:user_login] || raise(ConfigException, :user_login)
  @user_hash @config[:user_hash] || raise(ConfigException, :user_hash)
  @url @config[:url] || raise(ConfigException, :url)

  def url, do: @url

  def start(_type, _args) do
    children = [
      {Authorizer, [user_login: @user_login, user_hash: @user_hash]}
    ]

    opts = [strategy: :one_for_one, name: Amortizator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
