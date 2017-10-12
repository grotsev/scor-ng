create function application_create(
) returns uuid
  language plpgsql
as $function$
declare
  the_application uuid;
  the_borrower uuid;
begin

  insert into application (branch, outlet)
    select branch, outlet
    from actor_outlet
    where actor = current_actor()
  returning application into the_application;

  if not found then
    raise 'actor % (%) not found', current_login(), current_actor();
  end if;

  insert into application_stage(application, stage, blocked)
    values (the_application, 'attract', false);

  insert into contract_attract (application) values (the_application);

  insert into individual (application) values (the_application)
  returning individual into the_borrower;

  insert into individual_responsibility (application, individual, responsibility)
    values (the_application, the_borrower, 'borrower');

  return the_application;

end;
$function$;

comment on function application_create() is
  'Create new application';
