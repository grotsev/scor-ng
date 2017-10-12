create table contract
( primary key (application)
, foreign key (application)     references application
, foreign key (product)         references product
, foreign key (currency)        references currency
, foreign key (client_category) references client_category
, foreign key (product, currency, client_category, term_range, amount_range)
                                references product_scheme
, foreign key (repayment_kind)  references repayment_kind
, foreign key (income_evidence) references income_evidence
, foreign key (pledge_currency) references currency
, foreign key (credit_kind)     references credit_kind
, foreign key (credit_purpose)  references credit_purpose
) inherits (contract_history);
