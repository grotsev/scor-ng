create view contract_ext as
with monthly_payment as (
  select *
       , k1*total_income - k1_expenses    as monthly_payment_k1
       , k2*total_income - total_expenses as monthly_payment_k2
       , effective_term(repayment_kind, term, interest) as effective_term
  from contract
    inner join product_scheme as product using (product, currency, client_category, term_range, amount_range)
    inner join borrower_cashflow using (application)
), amount_calc as (
  select *
       , (pledge_value*ltv)                 ::monetary as amount_ltv
       , (monthly_payment_k1*effective_term)::monetary as amount_k1
       , (monthly_payment_k2*effective_term)::monetary as amount_k2
  from monthly_payment
)
select *
     , least(amount_ltv, amount_k1, amount_k2, amount) as amount_offer
from amount_calc;
