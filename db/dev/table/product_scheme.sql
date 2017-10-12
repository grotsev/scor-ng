create table product_scheme
( product           code not null
, currency          code not null
, client_category   code not null
, term_range   int4range not null
, amount_range int4range not null

, interest numeric not null
, k1       numeric not null
, k2       numeric not null
, ltv      numeric not null
, pledge   boolean not null
, actual   boolean not null default true

, primary key (product, currency, client_category, term_range, amount_range)
, foreign key (product)         references product
, foreign key (currency)        references currency
, foreign key (client_category) references client_category
);

comment on column product_scheme.interest is 'Percent per month';
comment on column product_scheme.term_range is 'In month';
