create table product
( product code not null

, primary key (product)
);


do $block$
begin
  execute (select macro_i18n('product'));
end;
$block$;
