create table individual
( application   uuid not null
, individual uuid_pk not null

, iin              iin
, surname    textfield
, name       textfield
, patronymic textfield
, dob             date
, gender          code

, nationality    code
, residency      code
, education      code
, speciality     code
, birthplace textarea

, marital_status  code
, children_lt_15  int4
, children_15_21  int4
--, children_total  int4 -- TODO move to view
, dependant_ge_21 int4

, address_reg  uuid
, address_fact uuid
, address_work uuid
, tenure       code
, tenancy_room int4

, email email

, photo uuid

, idcard_kind        code
, idcard_no     textfield
, idcard_series textfield
, idcard_term   daterange
, idcard_authority   code

, employment_self           boolean
, employment_title        textfield
, employment_position_category code
, employment_position     textfield
, employment_last_service      int4
, employment_total_service     int4
, employment_field        textfield

, employment2_title    textfield
, employment2_position textfield
, employment2_field    textfield

, primary key (application, individual)
, foreign key (application)                  references application
, foreign key (gender)                       references gender
, foreign key (nationality)                  references country
, foreign key (residency)                    references residency
, foreign key (education)                    references education
, foreign key (speciality)                   references speciality
, foreign key (marital_status)               references marital_status
, foreign key (application, address_reg)     references address on delete set null
, foreign key (application, address_fact)    references address on delete set null
, foreign key (application, address_work)    references address on delete set null
, foreign key (tenure)                       references tenure
, foreign key (idcard_kind)                  references idcard_kind
, foreign key (idcard_authority)             references idcard_authority
, foreign key (employment_position_category) references position_category
);

comment on table individual is 'Individual';
comment on column individual.idcard_no is 'Number';
comment on column individual.employment_self is 'Is businessman';
comment on column individual.employment_last_service is 'In month';
comment on column individual.employment_total_service is 'In month';
comment on column individual.employment_field is 'Company service domain';
comment on column individual.employment2_field is 'Company service domain';
comment on column individual.photo is 'Reference to external system';
