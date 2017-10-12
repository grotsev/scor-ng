create table actor
( actor uuid_pk not null

, login        login not null
, password_hash text not null
, current_rol   code

, primary key (actor)
, unique (login)
, foreign key (current_rol) references rol
);
