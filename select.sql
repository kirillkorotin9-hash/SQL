--создание
CREATE DATABASE `my_partners_db`;
USE `my_partners_db`;

--создание таблиц
CREATE TABLE `partner_types` (
    `id_type` INT NOT NULL PRIMARY KEY,
    `type_name` VARCHAR(50) NOT NULL
);




--Добавляем колонку для email в таблицу партнеров//
ALTER TABLE `business_partners` ADD COLUMN `email` VARCHAR(100) NULL AFTER `kpp`


--Обновление записей (UPDATE)//
UPDATE `business_partners` SET `email` = 'info@fason.ru' WHERE `id_partner` = 1000000000;





-- insert
INSERT INTO `business_partners` (`id_partner`, `partner_name`, `tax_id_inn`, `kpp`, `id_type`, `id_account_group`, `is_active`) VALUES
(1000000000, 'ООО "ФАСОН"', '5904329366', '590401001', 2, 1, 1),
(1000000001, 'ООО "КУРСКСПЕЦОДЕЖДА"', '4632008410', '463201001', 2, 1, 1),
(1000000014, 'ООО "ГК "ОЛВИТ"', '7810476129', '781001001', 2, 1, 1),
(1200000000, 'Фофанов Николай Сергеевич', '5908475139', '590801001', 1, 2, 1);


-- delete from
DELETE FROM `partner_roles` WHERE `id_partner` = 1000000001 AND `id_role_type` = 'CUS';




--неявное соединение таблиц с фильтром данных (WHERE) и сортировкой (ORDER BY)//
SELECT 
business_partners.partner_name AS 'Название партнера',
regions.region_name AS 'Регион',
address_data.city AS 'Город'
FROM 
business_partners, 
address_data, 
regions
WHERE 
business_partners.id_partner = address_data.id_partner 
AND address_data.id_region = regions.id_region AND regions.id_region = 59
ORDER BY 
business_partners.partner_name;


-- явное соединение таблиц (JOIN)//
SELECT business_partners.partner_name AS 'Партнер',
bank_accounts.bank_name AS 'Банк',
bank_accounts.account_number AS 'Расчетный счет'
FROM 
business_partners
JOIN 
bank_accounts ON business_partners.id_partner = bank_accounts.id_partner
WHERE 
bank_accounts.bank_name like "%ВТБ%";




--Агрегирующие операции (SUM, AVG, COUNT, MAX, MIN)//
SELECT 
COUNT(customer_data.id_partner) AS 'Всего клиентов',
SUM(customer_data.credit_limit) AS 'Общая сумма лимитов',
AVG(customer_data.credit_limit) AS 'Средний лимит',
MAX(customer_data.credit_limit) AS 'Максимальный лимит',
MIN(customer_data.credit_limit) AS 'Минимальный лимит'
FROM 
customer_data;




--Найти все регионы, в которых зарегистрировано больше одного делового партнера//
SELECT 
regions.region_name AS 'Название региона',
COUNT(address_data.id_partner) AS 'Количество партнеров'
FROM 
regions
JOIN 
address_data ON regions.id_region = address_data.id_region
GROUP BY 
regions.region_name
HAVING 
COUNT(address_data.id_partner) >1;





--запрос в запросе//
SELECT 
business_partners.partner_name AS 'Партнер-поставщик'
FROM 
business_partners
WHERE 
business_partners.id_partner IN (SELECT vendor_data.id_partner FROM vendor_data)
AND business_partners.id_partner NOT IN (SELECT customer_data.id_partner FROM customer_data);




--if case
SELECT 
business_partners.partner_name AS 'Партнер',
customer_data.credit_limit AS 'Лимит',
CASE 
WHEN customer_data.credit_limit > 500000 THEN 'VIP'
ELSE 'Обычный'
END AS 'Класс',
IF(customer_data.credit_limit > 0, 'Да', 'Нет') AS 'Есть лимит?'    
FROM 
business_partners
JOIN 
customer_data ON business_partners.id_partner = customer_data.id_partner;


--create view
CREATE VIEW view_partners_banks AS
SELECT 
business_partners.partner_name AS 'Партнер',
bank_accounts.bank_name AS 'Название банка'
FROM 
business_partners
JOIN 
bank_accounts ON business_partners.id_partner = bank_accounts.id_partner;
SELECT * FROM view_partners_banks;



-- представление WITH
WITH ClientLimits AS (
SELECT 
business_partners.partner_name AS 'Партнер',
customer_data.credit_limit AS 'Лимит'
FROM 
business_partners
JOIN 
customer_data ON business_partners.id_partner = customer_data.id_partner
)
SELECT * FROM ClientLimits WHERE Лимит > 100000;




--CREATE INDEX
EXPLAIN SELECT * FROM business_partners WHERE tax_id_inn = '5904329366';
CREATE INDEX idx_tax_id_inn2 ON business_partners(tax_id_inn);
EXPLAIN SELECT * FROM business_partners WHERE tax_id_inn = '5904329366';



--START TRANSACTION
START TRANSACTION;

INSERT INTO business_partners (id_partner, partner_name, tax_id_inn, kpp, id_type, id_account_group, is_active) 
VALUES (1000000999, 'ООО "НОВЫЙ ПАРТНЕР"', '1234567890', '123401001', 2, 1, 1);

INSERT INTO address_data (id_partner, id_region, city, street, postal_code) 
VALUES (1000000999, 77, 'МОСКВА', 'УЛИЦА ТВЕРСКАЯ', '101000');

COMMIT; -- Фиксируем изменения (можно заменить на ROLLBACK для отмены)





--PREPARE, EXECUTE, DEALLOCATE
PREPARE search_partner_type FROM 'SELECT partner_name FROM business_partners WHERE id_type = ?';
SET @type_to_find = 2;
EXECUTE search_partner_type USING @type_to_find;




--procedure--
DROP PROCEDURE IF EXISTS CreditStats;
DELIMITER //
CREATE PROCEDURE CreditStats()
BEGIN
DECLARE var_min float;
DECLARE var_max float;
DECLARE var_avg float;
DECLARE var_sum float; 

SELECT 
MIN(credit_limit),
MAX(credit_limit),
AVG(credit_limit),
SUM(credit_limit)
INTO 
var_min,
var_max,
var_avg,
var_sum
FROM customer_data;
SELECT 
var_min AS 'Минимум',
var_max AS 'Максимум',
var_avg AS 'Среднее',
 var_sum AS 'Сумма';
END//
DELIMITER ;
CALL CreditStats();


