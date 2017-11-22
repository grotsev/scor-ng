create function auth
( seance   uuid
, login    login
, password textfield
) returns void
  language sql
  security definer
as $function$

  select http_post
  ( 'http://192.168.1.1/login'
  , $$pg_notify('$$||seance||$$', $1)$$
  , json_build_object('login', login, 'password', password)
  );

$function$;

comment on function auth(uuid, login, textfield) is
  'ACS request for login, role JWT token and list of available roles';
