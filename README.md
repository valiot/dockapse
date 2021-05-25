# Dockapse

A lightweight/configurable interface that allows us to run docker commands through elixir based on [simple_docker](https://github.com/annkissam/simple_docker).

The purpose is to be able to manage docker in [Nerves](https://www.nerves-project.org/).

NOTE: By default, Nerves images do not include `docker`, however, [valiot_system_rpi4](https://github.com/valiot/valiot_system_rpi4/commit/5640b2b112b4833d4fc21d56969c26161806a3a2) is a custom Nerves system that includes docker.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dockapse` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:dockapse, "~> 0.1.0"}]
end
```
