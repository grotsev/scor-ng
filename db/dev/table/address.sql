create table address
( application uuid not null
, address  uuid_pk not null

, country  code not null
, province code not null
, district code not null
, location code not null

, distreet textfield
, building textfield
, room     textfield
, postcode textfield

, primary key (application, address)
, foreign key (application)                           references application
, foreign key (country, province, district, location) references location
);

comment on column address.distreet is 'Street or city district';
