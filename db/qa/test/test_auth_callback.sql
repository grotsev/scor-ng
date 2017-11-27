create function test_auth_callback(
) returns setof text
  language plpgsql
  set role from current
as $function$
begin

  set role to anonymous;

  perform auth_callback('5d5ed668-d56a-421c-b616-8abdaf5c8c4e', to_json('{
    "body": {
        "guid": "${GUID}",
        "accountName": "${ACCOUNT}",
        "surname": "${ACCOUNT}_surname",
        "name": "${ACCOUNT}_name",
        "patronymic": "${ACCOUNT}_patronymic",
        "email": "${ACCOUNT}@example.com",
        "tabNumber": ${TAB_NUMBER},
        "isBlocked": false
    }}'::text));

end;
$function$;
