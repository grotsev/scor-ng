create table contract_template
( application     uuid not null

, product           code
, currency          code
, client_category   code
, term_range   int4range
, amount_range int4range
, term              int4 check (term between 0 and 1200 and term <@ term_range)
, amount        monetary

, repayment_kind           code
, income_evidence          code
, deposit_value        monetary
, property_value       monetary
, pledge_value         monetary
, pledge_currency          code
, init_payment         monetary
, init_payment_percent numeric
, pay_date                 int4 check (pay_date between 1 and 31)
, monthly_payment      monetary

, credit_kind    code
, credit_purpose code
);

comment on table contract_template is 'Application contract terms and conditions';
comment on column contract_template.term is 'In month';
