create function test_i18n(
) returns setof text
  language plpgsql
  set role scoring
as $function$
begin

  return next set_eq(
    $$
      select rel
      from rel
    $$,
    $$
      select table_name as rel
      from information_schema.tables
      where table_catalog = 'postgres'
        and table_schema = 'scoring'
    $$,
    'rel describes all tables'
  );

  return next set_eq(
    $$
      select rel, attr
      from attr
    $$,
    $$
      select table_name  as rel
           , column_name as attr
      from information_schema.columns
      where table_catalog = 'postgres'
        and table_schema = 'scoring'
    $$,
    'attr describes all columns'
  );

  return next is_empty(
    $$
      select *
      from rel
      where i18n_rus is null
    $$,
    'rel i18n is full'
  );

  return next is_empty(
    $$
      select *
      from attr
      where i18n_rus is null
    $$,
    'attr i18n is full'
  );

end;
$function$;
