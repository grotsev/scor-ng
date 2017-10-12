create function check_pin(
  the_application uuid,
  the_actor uuid,
  the_stage code
) returns setof text
  language plpgsql
as $function$
begin

  return next ok(
    exists (
      select
      from application_stage
      where application = the_application
        and stage = the_stage
        and not blocked
    ),
    'Application is in stage ' || the_stage
  );

  return next ok(
    exists (
      select
      from pinning
      where application = the_application
        and actor = the_actor
        and stage = the_stage
    ),
    'Application is pinned to stage ' || the_stage
  );

  return next throws_ok(
    $$select pin('$$||the_application||$$', '$$||the_stage||$$')$$,
    'duplicate key value violates unique constraint "pinning_pkey"',
    'Application is pinned just once'
  );

end;
$function$;
