create function check_pin_attract(
  the_application uuid
) returns setof text
  language plpgsql
as $function$
declare
  the_borrower uuid;
begin

  update contract_attract set
    product = 'needful_credit_mortgage',
    currency = 'kzt',
    client_category ='a1',
    term_range = '[12,120]',
    amount_range = '[10000,)',
    term = 16,
    amount = 2000000
  where application = the_application;

  select individual
  from individual_responsibility
  where application = the_application
    and responsibility = 'borrower'
  into strict the_borrower;

  update individual set
    iin = '850118400153',
    surname = 'Иванов',
    name = 'Иван',
    patronymic = 'Иванович',
    dob = '1985-01-18',
    gender = 'male',

    marital_status = 'married',
    children_lt_15 = 0,
    children_15_21 = 0,
    dependant_ge_21 = 0,

    tenure = 'self_property',

    photo = uuid_generate_v1mc(),

    employment_title = $$ТОО 'Assem'$$,
    employment_last_service = 12,
    employment_total_service = 48
  where application = the_application
    and individual = the_borrower;

  insert into individual_cashflow (application, individual, cashflow_kind, amount) values
      (the_application, the_borrower, 'salary_last_month'     , 500000),
      (the_application, the_borrower, 'salary_avg'            , 500000),
      (the_application, the_borrower, 'salary_spouse'         , 200000),
      (the_application, the_borrower, 'other_confirmed_income', 100000),

      (the_application, the_borrower, 'credit_pay', 0),
      (the_application, the_borrower, 'credit_card_limit', 0),
      (the_application, the_borrower, 'education', 100000),
      (the_application, the_borrower, 'tenancy', 0),
      (the_application, the_borrower, 'utilities', 50000),
      (the_application, the_borrower, 'communications', 10000),
      (the_application, the_borrower, 'personal', 150000),
      (the_application, the_borrower, 'alimony', 0),
      (the_application, the_borrower, 'other_expenses', 0),
      (the_application, the_borrower, 'insurance', 15000),
      (the_application, the_borrower, 'commission', 15000),

      (the_application, the_borrower, 'transport_tax', 12000);

end;
$function$;
