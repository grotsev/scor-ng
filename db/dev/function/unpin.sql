create function unpin(
  the_application uuid,
  back_stage code default null,
  reset boolean default false
) returns void
  language plpgsql
as $function$
declare
  the_stage code;
begin

  -- TODO trace dump

  -- update application_stage

  select stage
  from pinning
  where application = the_application
    and actor = current_actor()
  into the_stage;

  if back_stage is null then -- decision tree stage transition

    delete from application_stage
    where application = the_application
      and stage = the_stage;

    insert into application_stage (application, stage, blocked) (
      select the_application, forth, false
      from rework
      where application = the_application
        and back = the_stage
    ) on conflict do nothing;

    if not found then -- no rework, route

      insert into application_stage (application, stage, blocked) (
        select the_application, stage, true
        from route(the_application, the_stage) stage
      ) on conflict do nothing;

      if true = all (
        select blocked
        from application_stage
        where application = the_application
      ) then
        update application_stage a set
          blocked = false
        where application = the_application;
      end if;

    end if;

  elseif not reset then -- rework back and forth stage transition

    delete from application_stage
    where application = the_application
      and stage = the_stage;

    insert into rework (application, back, forth)
    values (the_application, back_stage, the_stage);

    insert into application_stage (application, stage, blocked)
    values (the_application, back_stage, false);

  else -- reset stage transition

    delete from application_stage
    where application = the_application;

    insert into application_stage (application, stage, blocked)
    values (the_application, back_stage, false);

  end if;

  -- unpin application from actor

  delete from pinning
  where application = the_application;

end;
$function$;

comment on function unpin(uuid,code,boolean) is
  'Unpin application pinned by current_actor, move draft dependent objects into last state and perform stage business logic';
