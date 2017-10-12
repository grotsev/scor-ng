create table rol
( rol code not null

, primary key (rol)
);

comment on table rol is
  'Role';

do $block$
begin
  execute (select macro_i18n('rol'));
end;
$block$;
