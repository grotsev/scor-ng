grant execute on function
/*  authenticate(login,text)
, authorize(code)
, current_actor()
, current_login()
, current_rol()
, available_role()
, auth_z(login,text)*/
  current_actor()
, channel_seance(uuid)
to authenticator, anonymous, routine, admin;

grant execute on function
  auth_callback(uuid, json)
to http;

/*
grant execute on function
  -- system
  -- actor
  -- product
  -- application
  pin(uuid,code)
, unpin(uuid,code,boolean)
, route(uuid,code)
, route_default(uuid,code)
  -- address
  -- pledge
  -- contract
  -- person
  -- pkb
  -- formula
, score(pkb)
, effective_term(code,int4,numeric)
to routine;

grant execute on function
  application_create()
to attract;
*/