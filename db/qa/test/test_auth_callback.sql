create function test_auth_callback(
) returns setof text
  language plpgsql
  set role from current
as $function$
begin

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
    , $$ values ('admin'         , 'admin_surname', 'admin_name', 'admin_patronymic', 'admin@example.com', '1'             , false      )$$
    );

end;
$function$;
