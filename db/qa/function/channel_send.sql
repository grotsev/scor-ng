create or replace function channel_send
( seance uuid
, msg    json
) returns void
  language sql
  volatile
  strict
  security definer
as $function$

  insert into syslog(category, tag, msg) values ('test', 'seance/'||seance, msg::text);

$function$;

comment on function channel_send(uuid,json) is
  'Fake send to named Web Socket channel';
