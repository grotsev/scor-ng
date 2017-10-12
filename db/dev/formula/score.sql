create function score(
  pkb pkb
) returns numeric(3, 2)
  language plpgsql
  immutable -- WARN
as $function$
declare
  credit_count_factor numeric(3, 2);
  current_credit_amount_factor numeric(3, 2);
begin

  credit_count_factor = case coalesce(pkb.current_credit_count, 0)
    when 0 then 1
    when 1 then 0.8
    when 2 then 0.6
    when 3 then 0.4
    else 0.2
  end;

  current_credit_amount_factor = case
    when pkb.current_credit_amount is null then 1
    when pkb.current_credit_amount <= 100000 then 1
    when pkb.current_credit_amount <= 500000 then 0.8
    when pkb.current_credit_amount <= 1000000 then 0.6
    else 0.2
  end;

  return credit_count_factor * current_credit_amount_factor;

end;
$function$;

comment on function score(pkb) is
  'Score by PKB credit history';
