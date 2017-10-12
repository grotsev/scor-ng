create table individual_kin
( application uuid not null
, individual  uuid not null
, kin         uuid not null

, kinship code not null

, primary key (application, individual, kin)
, foreign key (application, individual) references individual
, foreign key (application, kin)        references individual
, foreign key (kinship)                 references kinship
);
