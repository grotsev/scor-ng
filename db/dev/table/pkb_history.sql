create table pkb_history
( application uuid not null

, current_credit_count      int4
, surname              textfield
, name                 textfield
, patronymic           textfield
, current_overdue       monetary
, balance_write_off      boolean
, right_reassign         boolean
, blank_loan_amount     monetary
, multiple_person_found  boolean
, unsecured_credit       boolean
, request_count_90          int4
, current_credit_amount monetary
);

comment on table pkb_history is
  'PKB service response history';
