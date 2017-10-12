insert into actor_rol
  select a.actor
       , o.login as role
  from actor a
    cross join actor o
  where a.login = 'all'
    and o.login != 'all'
;

insert into actor_rol
  select actor
       , login as role
  from actor
  where login != 'all'
;
