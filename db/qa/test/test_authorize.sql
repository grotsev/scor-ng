create function test_authorize(
) returns setof text
  language plpgsql
  set role from current
as $function$
begin

  set local role anonymous;
  set local jwt.claims.login = 'all';
  set local jwt.claims.actor = '11110000-0000-0000-0000-000011110000';
  return next is(
    authorize('attract')::jwt_token,
    row(
      'all',
      '11110000-0000-0000-0000-000011110000'::uuid,
      'attract'::name,
      extract(epoch from (now() + interval '1 week'))
    )::jwt_token,
    'user [all] is able to authorize as [attract]'
  );

  set local jwt.claims.login = 'attract';
  set local jwt.claims.actor = '11110000-0000-0000-0000-000011110002';
  return next is(
    authorize('attract')::jwt_token,
    row(
      'attract',
      '11110000-0000-0000-0000-000011110002'::uuid,
      'attract'::name,
      extract(epoch from (now() + interval '1 week'))
    )::jwt_token,
    'user [attract] is able to authorize as [attract]'
  );

  set local jwt.claims.login = 'attract';
  set local jwt.claims.actor = '11110000-0000-0000-0000-000011110002';
  return next is(
    authorize('administrator')::jwt_token,
    row(
      'attract',
      '11110000-0000-0000-0000-000011110002'::uuid,
      'anonymous'::name,
      extract(epoch from (now() + interval '1 week'))
    )::jwt_token,
    'user [attract] is not able to authorize as [admin]'
  );

end;
$function$;
