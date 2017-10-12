create table country
( country code not null

, primary key (country)
);

comment on table country is 'ISO 3166-1';


do $block$
begin
  execute (select macro_i18n('country'));
end;
$block$;
