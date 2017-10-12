create table stage
( stage code not null

, primary key (stage)
);

comment on table stage is
  'Stage is tightly related to agent which pin application to process';


do $block$
begin
  execute (select macro_i18n('stage'));
end;
$block$;
