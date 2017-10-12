create table responsibility
( responsibility code not null

, primary key (responsibility)
);

comment on table responsibility is 'Responsibility according to contract';


do $block$
begin
  execute (select macro_i18n('responsibility'));
end;
$block$;
