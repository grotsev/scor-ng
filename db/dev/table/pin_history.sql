create table pinning_history
( application     uuid not null
, sys_period tstzrange not null
, actor           uuid not null
, stage           code not null
);
