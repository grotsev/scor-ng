-- WARN current_role is reserved word
create function current_rol(
) returns name
  language plpgsql
  stable
  security definer
as $function$
declare
  result name;
begin
  select current_setting('jwt.claims.role') into result;
  return result;
exception
  when undefined_object then
    return null;
end;
$function$;

comment on function current_rol() is 'Get current role by JWT';
