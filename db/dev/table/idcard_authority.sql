create table idcard_authority
( idcard_authority code not null

, primary key (idcard_authority)
);


do $block$
begin
  execute (select macro_i18n('idcard_authority'));
end;
$block$;
