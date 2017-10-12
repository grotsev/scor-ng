create table phone_kind
( phone_kind code not null

, primary key (phone_kind)
);


do $block$
begin
  execute (select macro_i18n('phone_kind'));
end;
$block$;
