

insert into ws_r_action(id, state_name) values(1, 'Запрос принят от ГЦП');
insert into ws_r_action(id, state_name) values(2, 'Принятый запрос от ГЦП отправлен на ЦЕП');
insert into ws_r_action(id, state_name) values(3, 'Ответ принят от ЦЕП на отправленный запрос');
insert into ws_r_action(id, state_name) values(4, 'Запрос принят от ЦЕП');
insert into ws_r_action(id, state_name) values(5, 'Ответ на принятый запрос отправлен на ЦЕП');

insert into ws_method(id, method_name, crud_operation) values(1, '/v2/invoice/create', 'POST');
insert into ws_method(id, method_name, crud_operation) values(2, '/v2/invoice/send', 'POST');
insert into ws_method(id, method_name, crud_operation) values(3, '/v2/invoice/', 'GET');
insert into ws_method(id, method_name, crud_operation) values(4, '/v2/events/failed?date=', 'GET');
insert into ws_method(id, method_name, crud_operation) values(5, '/v2/invoice/reject?id=', 'DELETE');
insert into ws_method(id, method_name, crud_operation) values(6, '/v2/invoice/open?id=', 'PUT');

insert into ws_r_method(id, method_name) Values(1, 'Заявка на формирование инвойса');
insert into ws_r_method(id, method_name) Values(2, 'Получение уведомлений об оплате');
insert into ws_r_method(id, method_name) Values(3, 'Запрос сведений об инвойсе по серийному номеру инвойса');
insert into ws_r_method(id, method_name) Values(4, 'Запрос сведений о непринятых платежах');
insert into ws_r_method(id, method_name) Values(5, 'Аннулирование инвойса');
insert into ws_r_method(id, method_name) Values(6, 'Восстановление инвойса');

commit;
