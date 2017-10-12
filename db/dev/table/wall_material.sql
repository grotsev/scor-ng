create table wall_material
( wall_material code not null

, primary key (wall_material)
);


do $block$
begin
  execute (select macro_i18n('wall_material'));
end;
$block$;
