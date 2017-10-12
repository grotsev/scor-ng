create table product_fee
( product           code not null
, currency          code not null
, client_category   code not null
, term_range   int4range not null
, amount_range int4range not null
, fee               code not null

, primary key (product, currency, client_category, term_range, amount_range, fee)
, foreign key (product, currency, client_category, term_range, amount_range) references product_scheme
, foreign key (fee)                                                          references fee
);
