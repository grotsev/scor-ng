create table currency
( currency code not null check (currency ~ '^[a-z]{3}$')

, primary key (currency)
);

comment on table currency is 'ISO 4217';


do $block$
begin
  execute (select macro_i18n('currency'));
end;
$block$;
