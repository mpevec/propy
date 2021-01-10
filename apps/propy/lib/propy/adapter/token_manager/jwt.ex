#adapter
defmodule Propy.Adapter.TokenManager.Jwt do
  @moduledoc """
    Implementation of IManageToken with Jose JWT
  """
  alias Propy.Domain.IManageToken
  alias Propy.Model.Token
  alias Propy.Schema.AppUser
  @behaviour IManageToken

  @impl IManageToken
  def create(%AppUser{} = user, opts \\ []) do
    issuer = get_option_or_env(opts, :jwt_issuer)
    expired_in = get_option_or_env(opts, :jwt_expiration_in_minutes) |> expire_in
    encoded_secret = get_option_or_env(opts, :jwt_secret_hs256_signature) |> encode_secret

    # JSON Web Keys
    jwk = %{
      "kty" => "oct",
      "k" => encoded_secret
    }

    # JSON Web Signature (JWS)
    jws = %{
      "alg" => "HS256"
    }

    # JSON Web Token (JWT)
    jwt = %{
      "iss" => issuer,
      "sub" => user.id_app_user,
      "exp" => expired_in,
      "name" => "#{user.first_name} #{user.last_name}",
    }

    {_, token} = JOSE.JWT.sign(jwk, jws, jwt) |> JOSE.JWS.compact()
    {:ok, %Token{jwt: token, expired_in: expired_in, sub: user.id_app_user}}
  end

  defp encode_secret(secret) do
    secret |> :jose_base64url.encode()
  end

  defp expire_in(expiration_time_minutes) do
    DateTime.utc_now() |> DateTime.add(expiration_time_minutes * 60, :second) |> DateTime.to_unix()
  end

  defp get_option_or_env(opts, opt, env) when is_list(opts) and is_atom(opt) and is_atom(env) do
    Keyword.get(opts, opt, Application.fetch_env!(:propy, env))
  end

  defp get_option_or_env(opts, opt_env) when is_list(opts) and is_atom(opt_env) do
    Keyword.get(opts, opt_env, Application.fetch_env!(:propy, opt_env))
  end
end
