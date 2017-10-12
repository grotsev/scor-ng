create function macro_history(
  actual      name,
  history     name
) returns text
  language plpgsql
  stable
as $function$
begin

  return format(
$macro$

alter table %1$s
  add column sys_period  tstzrange not null
, add column modified_by      uuid not null
, add column deleted_by       uuid
, add foreign key (modified_by) references actor
, add foreign key (deleted_by)  references actor;

create trigger "5_modified_data"
  before update on %1$s
  for each row
  execute procedure modified_data();

create trigger "6_modified_by"
  before insert or update on %1$s
  for each row execute procedure modified_by();

create trigger "6_deleted_by"
  before delete on %1$s
  for each row execute procedure deleted_by();

create trigger "8_versioning_update"
  before update on %1$s
  for each row
  when (new.modified_by <> old.modified_by)
  execute procedure versioning('sys_period', '%2$s', true);

create trigger "8_versioning_insert_delete"
  before insert or delete on %1$s
  for each row
  execute procedure versioning('sys_period', '%2$s', true);

$macro$
  , actual
  , history
  );

end;
$function$;

comment on function macro_history(name,name) is
  'Macro copy on write actual table to history table. Totally skip unmodified data and skip versioning for same modified_by';
