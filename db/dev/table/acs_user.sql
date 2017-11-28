create table acs_user
( actor         uuid        not null
, guid          uuid        not null
, account_name  textfield   not null
, surname       textfield
, name          textfield
, patronymic    textfield
, email         email
, tab_number    textfield
, is_blocked    boolean     not null

, current_rol   code        not null

, primary key   (actor)
, unique        (guid)
, foreign key   (actor)         references actor
, foreign key   (current_rol)   references rol
);
