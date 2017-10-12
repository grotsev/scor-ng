grant select on table
  -- system
  i18n
  -- actor
, actor
, branch
, outlet
, actor_outlet
, actor_rol
  -- product
, currency
, client_category
, product
, product_scheme
, fee_kind
, fee
, product_fee
, product
  -- application
, stage
  -- address
, country
, province
, district
, location
  -- pledge
, auto_brand
, auto_model
, pledge_kind
, wall_material
  -- contract
, credit_kind
, credit_purpose
, income_evidence
, repayment_kind
  -- person
, cashflow_kind
, education
, gender
, idcard_authority
, idcard_kind
, kinship
, marital_status
, phone_kind
, position_category
, residency
, responsibility
, speciality
, tenure
  -- pkb
to scoring_user;

-- copy from scoring_user
grant select, insert, update, delete on table
  -- system
  i18n
  -- actor
, actor
, branch
, outlet
, actor_outlet
, actor_rol
  -- product
, currency
, client_category
, product
, product_scheme
, fee_kind
, fee
, product_fee
, product
  -- application
, stage
  -- address
, country
, province
, district
, location
  -- pledge
, auto_brand
, auto_model
, pledge_kind
, wall_material
  -- contract
, credit_kind
, credit_purpose
, income_evidence
, repayment_kind
  -- person
, cashflow_kind
, education
, gender
, idcard_authority
, idcard_kind
, kinship
, marital_status
, phone_kind
, position_category
, residency
, responsibility
, speciality
, tenure
  -- pkb
to admin;

alter table actor_rol enable row level security;
create policy select_actor_rol
  on actor_rol
  for select
  using (actor = current_actor());
