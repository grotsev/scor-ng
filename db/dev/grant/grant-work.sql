grant select on table
  application
to scoring_user;

grant insert on table
  application
to attract;

grant select, insert, update on table
  -- system
  -- actor
  -- product
  -- application
  individual_responsibility
, pinning -- TODO rls
, application_stage
  -- address
, address
  -- pledge
, pledge
  -- contract
, contract
, contract_attract
, contract_history
  -- person
, legal_entity
, individual
, individual_cashflow
, individual_phone
, individual_kin
, pledge
  -- pkb
to scoring_user;

grant delete on table
  individual_responsibility
, pinning
, application_stage
, contract
, contract_attract
to scoring_user;

grant select, insert, update, delete on table
  rework
to scoring_user;
