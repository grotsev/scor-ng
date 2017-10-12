create table location
( country  code not null
, province code not null
, district code not null
, location code not null

, primary key (country, province, district, location)
, foreign key (country, province, district) references district
);


do $block$
begin
  execute (select macro_i18n('location'));
end;
$block$;
