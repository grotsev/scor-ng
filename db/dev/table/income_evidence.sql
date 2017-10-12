create table income_evidence
( income_evidence code not null

, primary key (income_evidence)
);


do $block$
begin
  execute (select macro_i18n('income_evidence'));
end;
$block$;
