create table kinship
( kinship code not null

, primary key (kinship)
);

comment on table kinship is 'Relationship to individual';


do $block$
begin
  execute (select macro_i18n('kinship'));
end;
$block$;
