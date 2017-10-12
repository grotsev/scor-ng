create table credit_kind
( credit_kind code not null

, primary key (credit_kind)
);


do $block$
begin
  execute (select macro_i18n('credit_kind'));
end;
$block$;
