create table individual_cashflow
( application   uuid not null
, individual    uuid not null
, cashflow_kind code not null

, amount monetary not null

, primary key (application, individual, cashflow_kind)
, foreign key (application, individual) references individual
, foreign key (cashflow_kind)           references cashflow_kind
);
