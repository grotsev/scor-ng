create table syslog
( syslog   bigserial
, category text
, at       timestamptz not null default now()
, msg      text
);

