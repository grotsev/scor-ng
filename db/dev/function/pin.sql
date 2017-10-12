create function pin(
  the_application uuid,
  the_stage code
) returns void
  language plpgsql
as $function$
begin

  if not exists (
    select
    from application_stage
    where application = the_application
      and stage = the_stage
      and not blocked
  ) then
    raise 'No stage %', the_stage;
  end if;

  insert into pinning (application, actor, stage, sys_period)
    values (the_application, current_actor(), the_stage, tstzrange(now(), null) );

  if the_stage = 'declare' then

    insert into contract (
      select * from contract_attract
      where application = the_application
    ) on conflict on constraint contract_pkey do nothing;

  end if;

end;
$function$;

comment on function pin(uuid, code) is
  'Pin application to current_actor and create or copy draft from last state';
