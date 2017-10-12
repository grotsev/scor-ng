create table client_category
( client_category code not null

, primary key (client_category)
);


do $block$
begin
  execute (select macro_i18n('client_category'));
end;
$block$;
