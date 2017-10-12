create function modified_data(
) returns trigger
  language plpgsql
as $function$
begin
  new.modified_by = old.modified_by;
  if new = old then
    return null;
  end if;
  return new;
end;
$function$;

comment on function modified_data() is
  'Trigger reset modified_by and skip unmodified data';
