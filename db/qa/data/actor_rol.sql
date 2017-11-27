insert into actor_rol
  select a.actor
       , o.account_name as role
  from acs_user a
    cross join acs_user o
  where a.account_name = 'all'
    and o.account_name != 'all'
;

insert into actor_rol
  select actor
       , account_name as role
  from acs_user
  where account_name != 'all'
;
