create function auth(
  the_login text,
  the_rol name
) returns jwt_token
  language plpgsql
  security definer
as $function$
declare
  the_actor uuid;
begin
  select s.actor
  from actor s
    inner join actor_rol r on s.actor = r.actor
  where s.login = the_login
    and r.rol = the_rol
  into the_actor;

  if not found then
    raise 'actor with login % and rol % is not found', the_login, the_rol;
  end if;

  return (
      the_actor
    , the_rol
    , extract(epoch from (now() + interval '1 week'))
    , null -- TODO seance
  )::jwt_token;
end;
$function$;

comment on function auth(text, name) is
  'Authenticate and authorize without password but check actor_rol';
