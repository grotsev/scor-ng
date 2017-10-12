create function modified_by(
) returns trigger
  language plpgsql
as $function$
begin
  new.modified_by = current_actor();
  return new;
end;
$function$;
