create function auth_callback
( seance   uuid
, response json
) returns void
  language plpgsql
  security definer
as $function$
begin

    case (response#>'{status}')::text
    when '200' then

        if not exists (select actor from acs_user where guid = response#>'{body,guid}') then
            with rows as (
                insert into actor (actor) values (uuid_generate_v1mc()) returning actor
            )
            insert into acs_user(actor, guid, account_name, surname, name, patronymic
                , email, tabNumber, isBlocked, current_rol)
            select actor
                 , response#>'{body,guid}'
                 , response#>'{body,accountName}'
                 , response#>'{body,surname}'
                 , response#>'{body,name}'
                 , response#>'{body,patronymic}'
                 , response#>'{body,email}'
                 , response#>'{body,tabNumber}'
                 , response#>'{body,isBlocked}'
                 , 'anonymous'
            from rows;
        else
            update acs_user
            set account_name = response#>'{body,accountName}'
              , surname     = response#>'{body,surname}'
              , name        = response#>'{body,name}'
              , patronymic  = response#>'{body,patronymic}'
              , email       = response#>'{body,email}'
              , tabNumber   = response#>'{body,tabNumber}'
              , isBlocked   = response#>'{body,isBlocked}'
            where guid      = response#>'{body,guid}';
        end if;

        with u as (
            select *
            from acs_user u
            where guid = response#>'{body,guid}'
        )
        select pg_notify
            ( 'seance/'||seance
            , json_build_object
                ( 'rol'    , u.current_rol
                , 'actor'  , u.actor
                , 'login'  , u.account_name
                , 'surname', u.surname
                , 'name'   , u.name
                , 'token'  , sign
                    ( json_build_object
                        ( 'actor', actor
                        , 'role', current_rol
                        , 'exp', extract(epoch from (now() + interval '1 week'))
                        , 'seance', seance
                        )
                    , current_setting('app.jwt_secret')
                    )
                )
            )
        from u;

    when '450' then
        perform pg_notify('seance/'||seance, '"Blocked"');
    when '404' then
        perform pg_notify('seance/'||seance, '"NotFound"');
    else
        perform pg_notify('seance/'||seance, '"UndefinedError"');
    end case;

end;
$function$;

comment on function auth_callback(uuid, json) is
  'Response to client seance';
