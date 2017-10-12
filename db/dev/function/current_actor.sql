create function current_actor(
) returns uuid
  language plpgsql
  stable
  security definer
as $function$
declare
  result uuid;
begin
  select current_setting('jwt.claims.actor') into result;
  return result;
exception
  when undefined_object then
    return null;
end;
$function$;

comment on function current_actor() is 'Get current actor by JWT';
