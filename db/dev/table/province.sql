create table province
( country  code not null
, province code not null

, primary key (country, province)
, foreign key (country) references country
);


do $block$
begin
  execute (select macro_i18n('province'));
end;
$block$;
