create function port_http
( request http_request
, callback     text
) returns void
  language sql
  security definer
as $function$

  select pg_notify
  ( 'http'
  , row_to_json(row(request, callback)::http_call)::text
  );

$function$;

comment on function port_http(http_request,text) is
  'Transfer http POST request to listener';
