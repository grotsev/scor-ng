create function route_default(
  the_application uuid,
  the_stage code
) returns setof code
  language plpgsql
  stable -- WARN
as $function$
declare
  amount monetary;
begin

  case the_stage
    when 'attract' then
      return next 'blacklist';
      return next 'terrolist';
    when 'blacklist', 'terrolist' then
      return next 'declare';
    when 'declare' then
      return next 'verify';
    when 'verify' then
      return next 'pledgerate';
      return next 'lawyer';
      select x.amount from contract x where application = the_application into amount;
      if amount >= 1000000 then
        return next 'security';
      end if;
      return next 'risk';
    when 'pledgerate' then
      return next 'middle';
    when 'lawyer' then
      return next 'middle';
    when 'security' then
      return next 'middle';
    when 'risk' then
      select x.amount from contract x where application = the_application into amount;
      if amount >= 1000000 then
        return next 'creditcom';
      else
        return next 'retailcom';
      end if;
    when 'retailcom' then
      null;
    when 'creditcom' then
      null;
    when 'middle' then
      return next 'signing';
    when 'signing' then
      if true then -- TODO change to has pledge
        return next 'pledgereg';
      else
        return next 'creditadmin';
      end if;
    when 'pledgereg' then
      return next 'creditadmin';
    when 'creditadmin' then
      -- The end, do nothing
    else
      assert false, 'Unhandled stage ' || the_stage;
  end case;

end;
$function$;

comment on function route_default(uuid, code) is
  'Default route for vast mayority of products mostly based on current stage';
