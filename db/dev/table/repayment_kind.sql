create table repayment_kind
( repayment_kind code not null

, primary key (repayment_kind)
);


do $block$
begin
  execute (select macro_i18n('repayment_kind'));
end;
$block$;
