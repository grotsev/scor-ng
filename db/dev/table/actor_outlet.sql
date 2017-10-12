create table actor_outlet
( actor uuid not null
, branch code
, outlet code

, primary key (actor)
, foreign key (actor)          references actor
, foreign key (branch, outlet) references outlet
);
