create view borrower_cashflow as
select application
     , sum(total_income)   as total_income
     , sum(total_expenses) as total_expenses
     , sum(k1_expenses)    as k1_expenses
from individual_cashflow_total
  inner join individual_responsibility using (application, individual)
where responsibility = 'borrower'
group by application;
