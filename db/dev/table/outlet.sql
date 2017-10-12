create table outlet
( branch code not null
, outlet code not null

, primary key (branch, outlet)
, foreign key (branch) references branch
);

comment on table outlet is 'Retail trade point division';

do $block$
begin
  execute (select macro_i18n('outlet'));
end;
$block$;
