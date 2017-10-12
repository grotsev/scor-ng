create domain login as text
  check (value ~ '^[A-Za-z][A-Za-z_0-9]{0,31}$');
