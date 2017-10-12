create table actor_rol
( actor uuid not null
, rol   code not null

, primary key (actor, rol)
, foreign key (actor) references actor
, foreign key (rol)   references rol
);
