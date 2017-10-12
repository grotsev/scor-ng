create table rel
( rel name not null

, primary key (rel)
);

comment on table rel is
  'Relation';

do $block$
begin
  execute (select macro_i18n('rel'));
end;
$block$;
