create function assign_outlet(
) returns trigger
  language plpgsql
as $function$
begin
  select branch, outlet
  from actor_outlet
  where actor = current_actor()
  into new.branch, new.outlet;
  return new;
end;
$function$;
