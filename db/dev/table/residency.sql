create table residency
( residency code not null

, primary key (residency)
);


do $block$
begin
  execute (select macro_i18n('residency'));
end;
$block$;
