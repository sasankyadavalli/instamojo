# Instamojo

**Elixir bindings for Instamojo REST API.**

## Installation

The package can be installed by adding :instamojo to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:instamojo, "~> 0.1.0"}
  ]
end
```
Docs can be found at [https://hexdocs.pm/instamojo](https://hexdocs.pm/instamojo).

## Configuration

```elixir
config :instamojo,
  key: "INSTAMOJO_API_KEY",
  token: "INSTAMOJO_AUTH_TOKEN"
```