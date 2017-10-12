create table legal_entity
( application     uuid not null
, legal_entity uuid_pk not null

, title textfield

, primary key (application, legal_entity)
, foreign key (application) references application
);

comment on table legal_entity is 'Legal entity';
