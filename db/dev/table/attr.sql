create table attr
( attr name not null

, primary key (attr)
);

-- not in relation scope
comment on table attr is
  'Attribute in global scope';


do $block$
begin
  execute (select macro_i18n('attr'));
end;
$block$;
