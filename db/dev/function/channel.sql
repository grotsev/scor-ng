create or replace function channel
( name text
) returns text
  language sql
  stable
  strict
  security definer
as $function$

  with data(channel, mode) as (
    values (name   , 'r' )
  )
  select sign
    ( row_to_json(data)
    , current_setting('app.jwt_secret')
    )
  from data;

$function$;

comment on function channel(text) is
  'Named Web Socket channel JWT';
