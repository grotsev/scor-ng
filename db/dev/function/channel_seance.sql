create or replace function channel_seance
( seance uuid
) returns text
  language sql
  stable
  strict
  security definer
as $function$

  select channel('seance/' || seance);

$function$;

comment on function channel_seance(uuid) is
  'Seance Web Socket channel JWT';
