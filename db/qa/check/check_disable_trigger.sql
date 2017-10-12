create function check_disable_trigger(
) returns setof text
  language plpgsql
  set role scoring
as $function$
declare
  cursor refcursor;
begin

  return next is_empty(
    $$
      select application
      from only contract_history
      where application = '11120000-0000-0000-0000-000011110000'
    $$,
    'performance disable-trigger disabled contract_history is_empty'
  );

  return next isnt_empty(
    $$
      select application
      from only contract_history
      where application = '11120000-0000-0000-0000-000011110001'
    $$,
    'performance disable-trigger enabled contract_history isnt_empty'
  );

end;
$function$;
