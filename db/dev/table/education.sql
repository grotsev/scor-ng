create table education
( education code not null

, primary key (education)
);


do $block$
begin
  execute (select macro_i18n('education'));
end;
$block$;
