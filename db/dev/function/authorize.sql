create function authorize(
  rol code
) returns jwt_token
  language plpgsql
  stable
  strict
  security definer
as $function$
begin
  select a.rol
  from actor_rol a
  where a.actor = current_actor()
    and a.rol = authorize.rol
  into authorize.rol;

  return (
      current_login()
    , current_actor()
    , coalesce(authorize.rol, 'anonymous')
    , extract(epoch from (now() + interval '1 week'))
  )::jwt_token;
end;
$function$;

comment on function authorize(code) is
  'Creates a JWT token that will securely authorize actor';
