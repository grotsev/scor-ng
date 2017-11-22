create function http_get
( url       text
, callback  text
) returns void
  language sql
  security definer
as $function$

  select pg_notify
  ( 'http'
  , json_build_object(
        'method', 'GET',
        'url', url,
        'callback', callback
    )::text
  );

$function$;

comment on function http_get(text,text) is
  'Transfer http GET request to listener';
