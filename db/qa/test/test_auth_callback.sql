create function test_auth_callback(
) returns setof text
  language plpgsql
  set role from current
as $function$
declare
  result_json json;
  result_text text;
begin

  -- success

  set role to http;

  perform auth_callback('5d5ed668-d56a-421c-b616-8abdaf5c8c4e', '
    {
      "status":200,
      "body": {
        "body": {
          "user": {
            "accountName":"admin",
            "email":"admin@example.com",
            "guid":"5d5ed668-d56a-421c-b616-8abdaf5c8c4f",
            "isBlocked":false,
            "name":"admin_name",
            "patronymic":"admin_patronymic",
            "surname":"admin_surname",
            "tabNumber":1
          },
          "roles": [
            {
              "code":"ADMINISTRATOR",
              "functions": [
                {
                  "code":"ADMINISTRATOR",
                  "id":"1",
                  "name":"ADMINISTRATOR"
                },
                {
                  "code":"CAN_ADMIN_HSBK_CONTRACT",
                  "id":"2",
                  "name":"CAN_ADMIN_HSBK_CONTRACT"
                }
              ],
              "id":"1",
              "name":"Администратор"
            }
          ]
        }
      }
    }
  '::text::json);

  set role to test_check;

  return next results_eq
    ( $$select account_name::text, surname::text  , name::text  , patronymic::text  , email::text        , tab_number::text, is_blocked from acs_user where guid='5d5ed668-d56a-421c-b616-8abdaf5c8c4f'$$
    , $$values ('admin'          , 'admin_surname', 'admin_name', 'admin_patronymic', 'admin@example.com', '1'             , false      )$$
    , 'auth result is inserted into acs_user'
    );

  select msg::json from syslog where category='seance/5d5ed668-d56a-421c-b616-8abdaf5c8c4e'
  into result_json;

  return next is((result_json#>'{account_name}')::text, 'admin', 'Web socket response.admin is set');

  -- blocked

  set role to http;

  perform auth_callback('5d5ed668-d56a-421c-b616-8abdaf5c8c41', '{"status":450 }'::text::json);

  set role to test_check;

  select msg from syslog where category='seance/5d5ed668-d56a-421c-b616-8abdaf5c8c41'
  into result_text;

  return next is(result_text, 'Blocked', 'Web socket Blocked response');

  -- not found

  set role to http;

  perform auth_callback('5d5ed668-d56a-421c-b616-8abdaf5c8c42', '{"status":404 }'::text::json);

  set role to test_check;

  select msg from syslog where category='seance/5d5ed668-d56a-421c-b616-8abdaf5c8c42'
  into result_text;

  return next is(result_text, 'NotFound', 'Web socket NotFound response');

end;
$function$;
