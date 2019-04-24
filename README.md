# amortizator_elixir
Package for communicating with amoCRM API

# For developers

The following steps are required to test the library.

After cloning the repository create a new project somewhere in the upper directories (considering you're in the project directory):

```
$ cd ..
$ mix new test
$ cd test
```

Open `mix.exs` file in newly created project and change `deps` function like this:

```elixir
defp deps do
  [
    {:amortizator, path: "../amortizator", in_umbrella: true}
  ]
end
```

Then add goes the `application`:

```elixir
def application do
  [
    extra_applications: [:logger, :amortizator]
  ]
end
```

After the dependency were defined do `mix deps.get` and add configuration to `config/config.exs`:

```elixir
config :amortizator,
  url: System.get_env("TOTO_HOST"),
  user_login: System.get_env("TOTO_USER_LOGIN"),
  user_hash: System.get_env("TOTO_USER_HASH")
```

and set these environment variable. (As this project won't be published and shared, you cat set these values right in the config.)

Now you may want to run `mix compile` and `iex -S mix` to start testing.
