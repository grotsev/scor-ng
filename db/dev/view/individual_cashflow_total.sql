create view individual_cashflow_total as
select application
     , individual
     , (sum( amount/period) filter (where period > 0       ))::monetary as total_income
     , (sum(-amount/period) filter (where period < 0       ))::monetary as total_expenses
     , (sum(-amount/period) filter (where period < 0 and k1))::monetary as k1_expenses
from individual_cashflow
  inner join cashflow_kind using (cashflow_kind)
group by application, individual;
