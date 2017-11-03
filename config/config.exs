use Mix.Config

config :instamojo,
  key: System.get_env("INSTAMOJO_API_KEY"),
  token: System.get_env("INSTAMOJO_AUTH_TOKEN") 

