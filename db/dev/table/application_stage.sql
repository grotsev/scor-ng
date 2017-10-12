create table application_stage
( application uuid not null
, stage       code not null
, blocked  boolean not null

, primary key (application, stage)
, foreign key (application) references application
, foreign key (stage)       references stage
);

comment on table application_stage is
  'Next possible application stages blocked or available to actors';
