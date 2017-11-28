create function test_auth_callback(
) returns setof text
  language plpgsql
  set role from current
as $function$
begin

  set role to anonymous;

  perform auth_callback('5d5ed668-d56a-421c-b616-8abdaf5c8c4e', ('{"status":200,"body":{"body":{"accountName":"admin","email":"admin@example.com","guid":"5d5ed668-d56a-421c-b616-8abdaf5c8c4e","isBlocked":false,"name":"admin_name","patronymic":"admin_patronymic","surname":"admin_surname","tabNumber":1},"roles":[{"code":"ADMINISTRATOR","functions":[{"code":"ADMINISTRATOR","id":"1","name":"ADMINISTRATOR"},{"code":"CAN_ADMIN_HSBK_CONTRACT","id":"2","name":"CAN_ADMIN_HSBK_CONTRACT"}],"id":"1","name":"Администратор"}]}}'::text)::json);

end;
$function$;
