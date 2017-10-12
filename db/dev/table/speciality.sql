create table speciality
( speciality code not null

, primary key (speciality)
);


do $block$
begin
  execute (select macro_i18n('speciality'));
end;
$block$;
