create function auth_z( -- TODO
  login login,
  password text
) returns jwt_token
  language plpgsql
  stable
  strict
  security definer
as $function$
declare
  actor actor;
begin

  select a.* into actor
  from actor a
  where a.login = authenticate.login;

  if actor.password_hash = crypt(authenticate.password, actor.password_hash) then
    return (
        authenticate.login
      , actor.actor
      , 'anonymous'
      , extract(epoch from (now() + interval '1 week'))
    )::jwt_token;
  else
    return null;
  end if;

end;
$function$;

comment on function auth_z(login, text) is
  'Returns login, role JWT token and list of available roles';
