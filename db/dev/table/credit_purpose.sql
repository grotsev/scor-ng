create table credit_purpose
( credit_purpose code not null

, primary key (credit_purpose)
);


do $block$
begin
  execute (select macro_i18n('credit_purpose'));
end;
$block$;
