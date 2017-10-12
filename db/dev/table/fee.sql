create table fee
( fee code not null

, fee_kind   code not null
, percent numeric not null

, primary key (fee)
, foreign key (fee_kind) references fee_kind
);


do $block$
begin
  execute (select macro_i18n('fee'));
end;
$block$;
