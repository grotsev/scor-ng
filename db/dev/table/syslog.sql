create table syslog
( syslog   bigserial
, category text
, tag      text
, at       timestamptz not null default now()
, msg      text

, primary key (syslog)
);

