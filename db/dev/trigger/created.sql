create function created(
) returns trigger
  language plpgsql
as $function$
begin
  new.created_at = now();
  new.created_by = current_actor();
  return new;
end;
$function$;

comment on function created() is
  'Trigger to audit created_at and created_by. Requires current_actor()';
