create or replace function channel_send
( seance uuid
, msg    json
) returns void
  language sql
  volatile
  strict
  security definer
as $function$

  select pg_notify('seance/'||seance, msg::text);

$function$;

comment on function channel_send(uuid,json) is
  'Send to named Web Socket channel';
