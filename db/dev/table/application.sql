create table application
( application uuid_pk not null

, branch code not null
, outlet code not null

, primary key (application)
, foreign key (branch, outlet) references outlet
);

comment on table application is
  'Client application to get a product';
