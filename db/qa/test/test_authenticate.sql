create function test_authenticate(
) returns setof text
  language plpgsql
  set role from current
as $function$
begin

  set role to anonymous;

  return next is(
    authenticate('all', 'all')::jwt_token,
    row(
      'all',
      '11110000-0000-0000-0000-000011110000'::uuid,
      'anonymous',
      extract(epoch from (now() + interval '1 week'))
    )::jwt_token,
    'anonymous is able to authenticate'
  );

end;
$function$;
