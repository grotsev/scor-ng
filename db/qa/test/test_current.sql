create function test_current(
) returns setof text
  language plpgsql
  set role from current
as $function$
begin

  set local role anonymous;
  set local jwt.claims.actor = '11110000-0000-0000-0000-000011110000';
  set local jwt.claims.login = 'all';
  set local jwt.claims.role = 'attract';

  return next is(
    current_actor(),
    '11110000-0000-0000-0000-000011110000'::uuid,
    'current_actor() = jwt.claims.actor'
  );

  return next is(
    current_login(),
    'all',
    'current_login() = jwt.claims.login'
  );

  return next is(
    current_rol(),
    'attract'::name,
    'current_rol() = jwt.claims.role'
  );

end;
$function$;
