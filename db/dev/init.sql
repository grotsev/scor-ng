set client_min_messages to warning;
set plpgsql.extra_warnings to 'all';

drop schema if exists dev cascade;
create schema dev;
set search_path to dev, public;

alter default privileges for role scoring in schema dev revoke execute on functions from public;
