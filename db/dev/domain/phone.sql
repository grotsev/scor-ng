create domain phone as text
  check (value ~ '^+7\d{10}$')
;
