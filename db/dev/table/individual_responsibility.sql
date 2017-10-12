create table individual_responsibility
( application uuid not null
, individual  uuid not null

, responsibility code not null

, primary key (application, individual)
, foreign key (application)             references application
, foreign key (application, individual) references individual
, foreign key (responsibility)          references responsibility
);
