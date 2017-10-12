create table individual_phone
( application uuid not null
, individual  uuid not null
, phone      phone not null

, phone_kind code not null

, primary key (application, individual, phone)
, foreign key (application, individual) references individual
, foreign key (phone_kind)              references phone_kind
);
