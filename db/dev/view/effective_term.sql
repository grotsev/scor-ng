create function effective_term(
  repayment_kind code,
  term int4,
  interest numeric
) returns numeric
  language sql
  immutable
as $function$
  select case repayment_kind
    when 'annuity' then -- simplified sum of geometric progression
      (1 - (12/(12+interest)) ^ term) * 12 / interest
    when 'differentiated' then
      12*term / (interest*term + 12)
    end
$function$;

comment on function effective_term(code,int4,numeric) is
  'Auxilary to calculate amount_k1 and amount_k2 in contract_ext view';
