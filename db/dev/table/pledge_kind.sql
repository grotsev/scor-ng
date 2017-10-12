create table pledge_kind
( pledge_kind code not null

, primary key (pledge_kind)
);


do $block$
begin
  execute (select macro_i18n('pledge_kind'));
end;
$block$;
