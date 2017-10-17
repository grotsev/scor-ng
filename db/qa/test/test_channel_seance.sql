create function test_channel_seance
() returns setof text
  language plpgsql
  set role from current
as $function$
begin

  return next isnt(channel_seance(uuid_generate_v1mc()), null, 'Create seance channel');

end;
$function$;
