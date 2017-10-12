create table legal_entity_responsibility
( application  uuid not null
, legal_entity uuid not null

, responsibility code not null

, primary key (application, legal_entity)
, foreign key (application)               references application
, foreign key (application, legal_entity) references legal_entity
, foreign key (responsibility)            references responsibility
);
