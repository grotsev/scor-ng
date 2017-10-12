create table gender
( gender code not null

, primary key (gender)
);


do $block$
begin
  execute (select macro_i18n('gender'));
end;
$block$;
