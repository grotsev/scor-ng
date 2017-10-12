create table cashflow_kind
( cashflow_kind code not null
, period        int4 not null
, k1         boolean not null

, primary key (cashflow_kind)
);

comment on column cashflow_kind.period is 'In monthes, positive income, negative expences';


do $block$
begin
  execute (select macro_i18n('cashflow_kind'));
end;
$block$;
