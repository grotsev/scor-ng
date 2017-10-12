set client_min_messages to warning;
set plpgsql.extra_warnings to 'all';

drop schema if exists qa cascade;
create schema qa;
set search_path to qa, dev, public;

grant usage on schema dev to public;
grant usage on schema qa to public;
grant scoring to authenticator;
