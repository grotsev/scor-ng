create table pinning
( primary key (application)
, unique      (actor)
, foreign key (application) references application
, foreign key (actor)       references actor
, foreign key (stage)       references stage
) inherits (pinning_history);

comment on table pinning is 'actor which has pinned application for processing';
