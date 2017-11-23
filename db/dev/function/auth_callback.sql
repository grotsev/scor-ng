create function auth_callback
( seance   uuid
, response json
) returns void
  language sql
  security definer
as $function$

  select pg_notify('seance/'||seance, response::text);

$function$;

comment on function auth_callback(uuid, json) is
  'Response to client seance';
