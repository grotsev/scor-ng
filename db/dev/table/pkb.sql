create table pkb
( primary key (application)
, foreign key (application) references application
) inherits (pkb_history);

comment on table pkb is
  'PKB service response';
