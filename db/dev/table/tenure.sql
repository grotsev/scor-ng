create table tenure
( tenure code not null

, primary key (tenure)
);


do $block$
begin
  execute (select macro_i18n('tenure'));
end;
$block$;
