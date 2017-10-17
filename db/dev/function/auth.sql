create function auth
( seance   uuid
, login    login
, password textfield
) returns void
  language sql
  security definer
as $function$

  select port_http
  ( row
    ('post'
    , 'http://192.168.1.1/login'
    , '{}'
    , null
    , json_build_object('login', login, 'password', password)
    )::http_request
  , 'select auth_response(seance, $1)'
  );

$function$;

comment on function auth(uuid, login, textfield) is
  'ACS request for login, role JWT token and list of available roles';
