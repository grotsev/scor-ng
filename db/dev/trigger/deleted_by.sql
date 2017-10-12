create function deleted_by(
) returns trigger
  language plpgsql
as $function$
begin
  new.deleted_by = current_actor();
  return new;
end;
$function$;
