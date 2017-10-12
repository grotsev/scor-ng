create table branch
( branch code not null

, primary key (branch)
);

comment on table branch is 'Regional division';

do $block$
begin
  execute (select macro_i18n('branch'));
end;
$block$;
