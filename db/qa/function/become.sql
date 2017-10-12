create function become(
  token jwt_token
) returns uuid
  language plpgsql
as $function$
declare
  cmd text; -- TODO remove
begin
  -- TODO seance execute $$set local jwt.claims.login = '$$ || token.login || $$'$$;
  execute $$set local jwt.claims.role  = '$$ || token.role  || $$'$$;
  execute $$set local jwt.claims.actor = '$$ || token.actor || $$'$$;
  execute $$set local role $$ || token.role;

  return token.actor;
end;
$function$;

comment on function become(jwt_token) is
  'Become a actor and role';
