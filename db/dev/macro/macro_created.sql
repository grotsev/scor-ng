create function macro_created(
  the_table name
) returns text
  language plpgsql
  stable
as $function$
declare
begin

  return format(
$macro$

alter table %1$s
  add column created_at timestamptz not null
, add column created_by        uuid not null
, add foreign key (created_by) references actor;

create trigger "1_created"
  before insert on %1$s
  for each row execute procedure created();

$macro$
  , the_table
  );

end;
$function$;

comment on function macro_created(name) is
  'Macro audit created_at and created_by';
