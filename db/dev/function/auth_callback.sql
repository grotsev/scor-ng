create function auth_callback
( seance   uuid
, response json
) returns void
  language plpgsql
  security definer
as $function$
declare
    json_result json;
    the_error text;
    the_detail text;
begin

    case (response#>'{status}')::text
    when '200' then

        if not exists ( select actor from acs_user where guid = (response#>'{body,body,user,guid}')::text::uuid ) then
            with rows as (
                insert into actor (actor) values (uuid_generate_v1mc()) returning actor
            )
            insert into acs_user(actor, guid, account_name, surname, name, patronymic
                , email, tab_number, is_blocked, current_rol)
            select actor
                 , (response#>'{body,body,user,guid}')::text::uuid
                 , response#>'{body,body,user,accountName}'
                 , response#>'{body,body,user,surname}'
                 , response#>'{body,body,user,name}'
                 , response#>'{body,body,user,patronymic}'
                 , response#>'{body,body,user,email}'
                 , response#>'{body,body,user,tabNumber}'
                 , (response#>'{body,body,user,isBlocked}')::text::boolean
                 , 'anonymous'
            from rows;
        else
            update acs_user
            set account_name = response#>'{body,body,user,accountName}'
              , surname      = response#>'{body,body,user,surname}'
              , name         = response#>'{body,body,user,name}'
              , patronymic   = response#>'{body,body,user,patronymic}'
              , email        = response#>'{body,body,user,email}'
              , tab_number   = response#>'{body,body,user,tabNumber}'
              , is_blocked   = (response#>'{body,body,user,isBlocked}')::text::boolean
            where guid       = (response#>'{body,body,user,guid}')::text::uuid;
        end if;

        with u as (
            select *
            from acs_user u
            where guid = (response#>'{body,body,user,guid}')::text::uuid
        )
        select json_build_object
            ( 'rol'           , u.current_rol
            , 'actor'         , u.actor
            , 'account_name'  , u.account_name
            , 'surname'       , u.surname
            , 'name'          , u.name
            , 'token'         , sign
                ( json_build_object
                    ( 'actor', actor
                    , 'role', current_rol
                    , 'exp', extract(epoch from (now() + interval '1 week'))
                    , 'seance', seance
                    )
                , current_setting('app.jwt_secret')
                )
            )
        from u
        into json_result;

    when '450' then
        json_result = '"Blocked"';
    when '404' then
        json_result = '"NotFound"';
    else
        json_result = '"UndefinedError"';
    end case;

    perform channel_send(seance, json_result);

exception when others then
    get stacked diagnostics the_error = message_text;
    get stacked diagnostics the_detail = pg_exception_detail;
    raise exception '% %', the_error, the_detail;
end;
$function$;

comment on function auth_callback(uuid, json) is
  'Response to client seance';
