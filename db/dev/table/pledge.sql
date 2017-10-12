create table pledge
( application uuid not null
, pledge   uuid_pk not null

, pledge_kind code

-- FLAT, HOUSE, LAND, COMMERCIAL, AUTO, MACHINE
, production_year int4
, pledgor    textfield -- TODO change to foreign key
, condition  textfield
, note        textarea

-- FLAT, HOUSE, LAND, COMMERCIAL
, address               uuid
, cadastral_number textfield
, purpose          textfield
, lease_term            int4

-- FLAT, HOUSE, COMMERCIAL
, meterage_total  int4
, meterage_living int4
, build_storey    int4
, room            int4

-- FLAT, HOUSE
, wall_material code

-- HOUSE, LAND
, meterage_land int4

-- COMMERCIAL, OTHER
, specification textarea

-- AUTO, MACHINE
, auto_brand               code
, auto_model               code
, registration_number textfield
, color               textfield
, auto_volume           numeric

, primary key (application, pledge)
, foreign key (application)            references application
, foreign key (pledge_kind)            references pledge_kind
, foreign key (application, address)   references address
, foreign key (wall_material)          references wall_material
, foreign key (auto_brand)             references auto_brand
, foreign key (auto_brand, auto_model) references auto_model
);

comment on column pledge.lease_term is 'In month';
comment on column pledge.meterage_total is 'In square meter';
comment on column pledge.meterage_living is 'In square meter';
comment on column pledge.meterage_land is 'In square meter';
