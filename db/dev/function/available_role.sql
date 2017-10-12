create function available_role(
) returns setof name
  language plpgsql
  stable
  security definer
as $function$
begin

  return query
    select role
    from actor_rol
    where actor = current_actor();

end;
$function$;

comment on function available_role() is 'Get available role of current_actor';
