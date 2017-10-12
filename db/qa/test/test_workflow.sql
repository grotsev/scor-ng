create function test_workflow(
) returns setof text
  language plpgsql
  set role from current
as $function$
declare
  the_actor uuid;
  the_application uuid;

  the_stage code;
  stage_round int4;
  stage_name text;
  stage_function text;
  back_stage code;
  reset boolean;

  the_error text;
begin

  select become(auth('attract', 'attract')) into the_actor;
  the_application = application_create();
  return next diag('         check_application_create');
  return query select check_application_create(the_application, the_actor);

  foreach the_stage, stage_round, back_stage, reset in array array[
    ('attract'    ::code, null, null            , false),
    ('blacklist'  ::code, null, null            , false),
    ('terrolist'  ::code, null, null            , false),
    ('declare'    ::code, null, null            , false),
    ('verify'     ::code, null, null            , false),
    ('pledgerate' ::code, null, null            , false),
    ('lawyer'     ::code, null, 'declare'       , true),
    ('declare'    ::code, 2   , null            , false),
    ('verify'     ::code, 2   , null            , false),
    ('pledgerate' ::code, 2   , 'declare'       , false),
    --('pkb'        ::code, null, null            , false),
    ('lawyer'     ::code, 2   , null            , false),
    ('declare'    ::code, 3   , null            , false),
    ('pledgerate' ::code, 3   , null       , false),
    --('security'   ::code, null, null            , false), -- TODO amount >= 1000000
    ('risk'       ::code, null, null            , false),
    --('retailcom'  ::code, null, null            , false), -- amount >= 1000000
    ('creditcom'  ::code, null, null            , false),
    ('middle'     ::code, null, null            , false),
    ('signing'    ::code, null, null            , false),
    ('pledgereg'  ::code, null, null            , false),
    ('creditadmin'::code, null, null            , false)
  ] loop
    begin
      stage_name = lower(the_stage);
      stage_function = stage_name||coalesce('_'||stage_round, '');
      return next diag('  ', stage_function);
      select become(auth(stage_name, stage_name)) into the_actor;
      perform pin(the_application, the_stage);

      return next diag('         check_pin(', stage_function, ')');
      return query select check_pin(the_application, the_actor, the_stage);

      return next diag('         check_pin_', stage_function);
      return query execute 'select check_pin_'||stage_function||'($1)' using the_application;

      perform unpin(the_application, back_stage, reset);

      return next diag('         check_unpin_', stage_function);
      return query execute 'select check_unpin_'||stage_function||'($1)' using the_application;
    exception
      when others then
        GET STACKED DIAGNOSTICS the_error = message_text;
        return next fail(the_error);
        exit;
    end;
  end loop;

end;
$function$;
