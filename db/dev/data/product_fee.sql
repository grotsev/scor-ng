insert into product_fee
  select p.product, p.currency, p.client_category, p.term_range, p.amount_range, f.fee
  from product_scheme p
    cross join fee f
;
