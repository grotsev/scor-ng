create function route(
  the_application uuid,
  the_stage code
) returns setof code
  language plpgsql
  stable -- WARN
as $function$
declare
  the_product code;
begin

  select product from contract where application = the_application into the_product;

  if not found then
    select product from contract_attract where application = the_application into the_product;
  end if;

  case the_product
    when 'credit_card' then
      return query select route_credit_card(the_application, the_stage); -- TODO
    else
      return query select route_default(the_application, the_stage);
  end case;

end;
$function$;

comment on function route(uuid, code) is
  'Calculate next possible application stages mostly based on product';
