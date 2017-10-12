create table auto_brand
( auto_brand code not null

, primary key (auto_brand)
);


do $block$
begin
  execute (select macro_i18n('auto_brand'));
end;
$block$;
