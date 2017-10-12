create domain iin as text
  check (value ~ '^\d{12}$')
;
