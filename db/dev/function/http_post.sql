create function http_post
( url       text
, callback  text
, body      json
) returns void
  language sql
  security definer
as $function$

  select pg_notify
  ( 'http'
  , json_build_object(
        'method', json_build_object(
          'POST', json_build_object('body', body)
        ),
        'url', url,
        'callback', callback
    )::text
  );

$function$;

comment on function http_post(text,text,json) is
  'Transfer http POST request to listener';
