create table fee_kind
( fee_kind code not null

, primary key (fee_kind)
);


do $block$
begin
  execute (select macro_i18n('fee_kind'));
end;
$block$;
