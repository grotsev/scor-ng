create function test_score(
) returns setof text
  language plpgsql
  set role from current
as $function$
declare
  empty_pkb pkb;
  poor_pkb pkb;
begin

  set local role attract;

  empty_pkb = row(
    null::uuid,
    null::int4,
    null::textfield,
    null::textfield,
    null::textfield,
    null::monetary,
    null::boolean,
    null::boolean,
    null::monetary,
    null::boolean,
    null::boolean,
    null::int4,
    null::monetary,
    null::tstzrange,
    null::uuid,
    null::uuid
  )::pkb;

  return next is(
    score(empty_pkb),
    1::numeric(3, 2),
    'score(empty_pkb) = 1'
  );

  poor_pkb = row(
    null::uuid,
    2::int4,
    null::textfield,
    null::textfield,
    null::textfield,
    null::monetary,
    null::boolean,
    null::boolean,
    null::monetary,
    null::boolean,
    null::boolean,
    null::int4,
    500000::monetary,
    null::tstzrange,
    null::uuid,
    null::uuid
  )::pkb;

  return next is(
    score(poor_pkb),
    0.48::numeric(3, 2),
    'score(poor_pkb) = 0.48'
  );

end;
$function$;
