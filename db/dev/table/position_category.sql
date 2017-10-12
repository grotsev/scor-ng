create table position_category
( position_category code not null

, primary key (position_category)
);


do $block$
begin
  execute (select macro_i18n('position_category'));
end;
$block$;
