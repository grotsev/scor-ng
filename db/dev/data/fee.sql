insert into fee
  (fee                  , fee_kind    , percent, i18n_rus                                     )
values
  ('review'             , 'commission',       1, 'за рассмотрение заявки на получение кредита')
, ('overdue'            , 'fine'      ,       5, 'пеня за нарушение сроков платежа по ДБЗ'    )
, ('mandatory_insurance', 'insurance' ,       3, 'обязательное страхование'                   )
;
