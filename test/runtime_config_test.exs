defmodule ExclosuredApp.RuntimeConfigTest do
  # Mutates the OS environment, so it cannot share the scheduler with others.
  use ExUnit.Case, async: false

  @runtime_config Path.expand("../config/runtime.exs", __DIR__)
  @vars ~w(SECRET_KEY_BASE PHX_HOST PHX_CHECK_ORIGIN PORT)

  describe ":prod" do
    test "takes the host, port and secret from the environment" do
      endpoint =
        read_prod(%{
          "SECRET_KEY_BASE" => "a-real-secret",
          "PHX_HOST" => "exclosured.app",
          "PORT" => "4321"
        })

      assert endpoint[:url][:host] == "exclosured.app"
      assert endpoint[:url][:scheme] == "https"
      assert endpoint[:http][:port] == 4321
      assert endpoint[:secret_key_base] == "a-real-secret"
    end

    test "refuses to start without a secret" do
      assert_raise RuntimeError, ~r/SECRET_KEY_BASE is not set/, fn ->
        read_prod(%{})
      end
    end

    test "never falls back to the dev secret baked into config.exs" do
      endpoint = read_prod(%{"SECRET_KEY_BASE" => "a-real-secret"})
      refute endpoint[:secret_key_base] =~ "exclosured_app_secret_key_base_"
    end

    test "check_origin is on unless explicitly disabled" do
      assert read_prod(%{"SECRET_KEY_BASE" => "s"})[:check_origin]
      refute read_prod(%{"SECRET_KEY_BASE" => "s", "PHX_CHECK_ORIGIN" => "false"})[:check_origin]
    end

    test "defaults the port to the one config.exs uses" do
      assert read_prod(%{"SECRET_KEY_BASE" => "s"})[:http][:port] == 4000
    end
  end

  test "other environments are left untouched" do
    assert Config.Reader.read!(@runtime_config, env: :dev) == []
  end

  defp read_prod(vars) do
    saved = Map.new(@vars, &{&1, System.get_env(&1)})
    Enum.each(@vars, &System.delete_env/1)
    Enum.each(vars, fn {key, value} -> System.put_env(key, value) end)

    try do
      @runtime_config
      |> Config.Reader.read!(env: :prod)
      |> get_in([:exclosured_app, ExclosuredAppWeb.Endpoint])
    after
      Enum.each(saved, fn
        {key, nil} -> System.delete_env(key)
        {key, value} -> System.put_env(key, value)
      end)
    end
  end
end
