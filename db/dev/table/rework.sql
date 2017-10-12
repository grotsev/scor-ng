create table rework
( application uuid not null
, back        code not null
, forth       code not null

, primary key (application)
, foreign key (back)  references stage
, foreign key (forth) references stage
);

comment on table rework is
  'Fix mistakes in back stage and return forth. Other stages are untouched';
