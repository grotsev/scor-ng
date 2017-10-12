create function check_application_create(
  the_application uuid,
  the_actor uuid
) returns setof text
  language plpgsql
  set role scoring
as $function$
begin

  return next isnt(
    the_application,
    null,
    'application_create() create new application'
  );

end;
$function$;
