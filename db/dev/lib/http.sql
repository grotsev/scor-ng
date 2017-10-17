create domain http_method as text
check (
  value ilike 'get' or
  value ilike 'post' or
  value ilike 'put' or
  value ilike 'delete'
);

create domain content_type as text
  check (value ~ '^\s+\/\s+');

create type http_header as
( field varchar
, value varchar
);

create type http_request as
( method       http_method
, uri          varchar
, headers      http_header[]
, content_type varchar
, content      varchar
);

create type http_call as
( request  http_request
, callback text
);

create or replace function http_header
( field varchar
, value varchar
) returns http_header
  language 'sql'
as $function$
  select $1, $2
$function$;
