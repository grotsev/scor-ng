create table idcard_kind
( idcard_kind code not null

, primary key (idcard_kind)
);


do $block$
begin
  execute (select macro_i18n('idcard_kind'));
end;
$block$;
