create function current_actor(
) returns uuid
  language sql
  stable
  strict
  security definer
as $function$

  select current_setting('jwt.claims.actor', null)::uuid;

$function$;

comment on function current_actor() is 'Current actor by JWT';
