create table marital_status
( marital_status code not null

, primary key (marital_status)
);


do $block$
begin
  execute (select macro_i18n('marital_status'));
end;
$block$;
