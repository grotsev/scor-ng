create type jwt_token as (
  actor  uuid
, role   name
, exp    int4
, seance uuid
);
