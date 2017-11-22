create function auth
( seance   uuid
, login    login
, password textfield
) returns void
  language sql
  security definer
as $function$

  select http_post
  ( current_setting('app.acs.url') || '/access'
  , 'insert into syslog(msg) values ($1)'
  --, $$pg_notify('$$||seance||$$', $1)$$
  , json_build_object('accountName', login, 'password', password)
  );

$function$;

comment on function auth(uuid, login, textfield) is
  'ACS request for login, role JWT token and list of available roles';
