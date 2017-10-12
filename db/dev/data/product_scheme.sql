insert into product_scheme
  (product                 , currency, client_category, term_range, amount_range    , interest, k1, k2, ltv, pledge)
values
  ('needful_credit_mortgage', 'kzt'  , 'a1'           , '[12,120]', '[10000,)'      , 13.8    ,  1,  1,   0, false )
, ('needful_credit_mortgage', 'kzt'  , 'b1'           , '[12,120]', '[10000,100000)', 15      ,  1,  1,   0, false )
, ('needful_credit_mortgage', 'kzt'  , 'a2'           , '[12,120]', '[10000,100000)', 15      ,  1,  1,   0, false )
, ('needful_credit_mortgage', 'kzt'  , 'b2'           , '[12,120]', '[10000,100000)', 15      ,  1,  1,   0, false )
, ('needful_credit_mortgage', 'usd'  , 'a1'           , '[12,120]', '[1000,100000)' , 13      ,  1,  1,   0, false )
;
