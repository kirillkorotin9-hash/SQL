
DROP DATABASE IF EXISTS `my_partners_db`;
CREATE DATABASE `my_partners_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `my_partners_db`;


CREATE TABLE `partner_types` (
    `id_type` INT NOT NULL PRIMARY KEY,
    `type_name` VARCHAR(50) NOT NULL
);

CREATE TABLE `account_groups` (
    `id_group` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `group_name` VARCHAR(100) NOT NULL
);

CREATE TABLE `role_types` (
    `id_role_type` VARCHAR(20) NOT NULL PRIMARY KEY,
    `role_title` VARCHAR(100) NOT NULL
);

CREATE TABLE `regions` (
    `id_region` INT NOT NULL PRIMARY KEY,
    `region_name` VARCHAR(100) NOT NULL,
    `country_code` VARCHAR(3) NOT NULL
);

CREATE TABLE `business_partners` (
    `id_partner` INT NOT NULL PRIMARY KEY,
    `partner_name` VARCHAR(255) NOT NULL,
    `tax_id_inn` VARCHAR(12) NULL,
    `kpp` VARCHAR(9) NULL,
    `id_type` INT NOT NULL,
    `id_account_group` INT NOT NULL,
    `is_active` BOOLEAN DEFAULT 1,
    FOREIGN KEY (`id_type`) REFERENCES `partner_types`(`id_type`),
    FOREIGN KEY (`id_account_group`) REFERENCES `account_groups`(`id_group`)
);

CREATE TABLE `partner_roles` (
    `id_partner` INT NOT NULL,
    `id_role_type` VARCHAR(20) NOT NULL,
    `valid_from` DATE NOT NULL,
    PRIMARY KEY (`id_partner`, `id_role_type`),
    FOREIGN KEY (`id_partner`) REFERENCES `business_partners`(`id_partner`),
    FOREIGN KEY (`id_role_type`) REFERENCES `role_types`(`id_role_type`)
);

CREATE TABLE `address_data` (
    `id_address` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_partner` INT NOT NULL,
    `id_region` INT NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `street` VARCHAR(255) NOT NULL,
    `postal_code` VARCHAR(6) NOT NULL,
    FOREIGN KEY (`id_partner`) REFERENCES `business_partners`(`id_partner`),
    FOREIGN KEY (`id_region`) REFERENCES `regions`(`id_region`)
);

CREATE TABLE `bank_accounts` (
    `id_bank_acc` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_partner` INT NOT NULL,
    `bank_name` VARCHAR(255) NOT NULL,
    `bik` VARCHAR(9) NOT NULL,
    `account_number` VARCHAR(20) NOT NULL,
    `currency` VARCHAR(3) DEFAULT 'RUB',
    FOREIGN KEY (`id_partner`) REFERENCES `business_partners`(`id_partner`)
);

CREATE TABLE `customer_data` (
    `id_partner` INT NOT NULL PRIMARY KEY,
    `sales_org` VARCHAR(50) NOT NULL,
    `distr_channel` VARCHAR(50) NOT NULL,
    `credit_limit` DECIMAL(15, 2) DEFAULT 0,
    FOREIGN KEY (`id_partner`) REFERENCES `business_partners`(`id_partner`)
);

CREATE TABLE `vendor_data` (
    `id_partner` INT NOT NULL PRIMARY KEY,
    `purchasing_org` VARCHAR(50) NOT NULL,
    `purchase_currency` VARCHAR(3) DEFAULT 'RUB',
    `vendor_rating` DECIMAL(3, 2) NULL,
    FOREIGN KEY (`id_partner`) REFERENCES `business_partners`(`id_partner`)
);

CREATE TABLE `change_log` (
    `id_log` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `id_partner` INT NOT NULL,
    `change_date` DATETIME NOT NULL,
    `change_type` VARCHAR(50) NOT NULL,
    `initiator` VARCHAR(100) NOT NULL,
    `description` TEXT NULL,
    FOREIGN KEY (`id_partner`) REFERENCES `business_partners`(`id_partner`)
);


INSERT INTO `partner_types` (`id_type`, `type_name`) VALUES (1, 'Физлицо'), (2, 'Юрлицо');
INSERT INTO `account_groups` (`id_group`, `group_name`) VALUES (1, 'Z010 - ЮЛ'), (2, 'Z012 - ФЛ');
INSERT INTO `role_types` (`id_role_type`, `role_title`) VALUES ('CUS', 'Клиент'), ('SUP', 'Поставщик');
INSERT INTO `regions` (`id_region`, `region_name`, `country_code`) VALUES 
(32, 'Брянская область', 'RU'), (46, 'Курская область', 'RU'), (58, 'Пензенская область', 'RU'), 
(59, 'Пермский край', 'RU'), (63, 'Самарская область', 'RU'), (66, 'Свердловская область', 'RU'), 
(72, 'Тюменская область', 'RU'), (77, 'Москва', 'RU'), (78, 'Санкт-Петербург', 'RU'), (91, 'Республика Крым', 'RU');

-- 15 Партнеров
INSERT INTO `business_partners` (`id_partner`, `partner_name`, `tax_id_inn`, `kpp`, `id_type`, `id_account_group`, `is_active`) VALUES
(1000000000, 'ООО "ФАСОН"', '5904329366', '590401001', 2, 1, 1),
(1000000001, 'ООО "КУРСКСПЕЦОДЕЖДА"', '4632008410', '463201001', 2, 1, 1),
(1000000010, 'ООО "УК "ГРАДЭК-СЕРВИС"', '5838013550', '583801001', 2, 1, 1),
(1000000012, 'ТСЖ "КРАСНАЯ ГОРКА"', '5906139184', '590601001', 2, 1, 1),
(1000000013, 'ТСН "ВЛАДИМИРСКАЯ - 48"', '6311181946', '631101001', 2, 1, 1),
(1000000014, 'ООО "ГК "ОЛВИТ"', '7810476129', '781001001', 2, 1, 1),
(1000000015, 'ООО "ВК "ГУБАХА"', '5904246670', '592101001', 2, 1, 1),
(1000000016, 'ТСЖ "РАДУГА"', '3233500820', '325701001', 2, 1, 1),
(1000000018, 'ООО "АВАНГАРД-СЕРВИС"', '5948045604', '594801001', 2, 1, 1),
(1000000019, 'АО "ПО "УРАЛЦВЕТМЕТРЕМОНТ"', '6658159440', '665801001', 2, 1, 1),
(1000000020, 'ООО "МАЛЕЦКИЙ, ШЕЛИЯ И ПАРТНЁРЫ"', '9108111288', '910801001', 2, 1, 1),
(1000000021, 'ООО "ТЕХНОАЛЬЯНС"', '7203302112', '720301001', 2, 1, 1),
(1000000022, 'Филиал РТРС «Мурманский ОРТПЦ»', '7717127211', '519043001', 2, 1, 1),
(1000000023, 'ТСЖ "СИРЕНЕВЫЙ 7-1"', '7802351599', '780201001', 2, 1, 1),
(1200000000, 'Фофанов Николай Сергеевич', '5908475139', '590801001', 1, 2, 1);

-- Адреса
INSERT INTO `address_data` (`id_partner`, `id_region`, `city`, `street`, `postal_code`) VALUES
(1000000000, 59, 'ГОРОД ПЕРМЬ', 'УЛИЦА ГУСАРОВА, ДОМ 9', '614090'),
(1000000001, 46, 'ГОРОД КУРСК', 'УЛИЦА ЭНЕРГЕТИКОВ 3', '305018'),
(1000000010, 58, 'ГОРОД ЗАРЕЧНЫЙ', 'УЛИЦА АХУНСКАЯ, ДОМ', '442963'),
(1000000012, 59, 'ГОРОД ПЕРМЬ', 'УЛИЦА ФРЕЗЕРОВЩИКОВ, Д', '614060'),
(1000000013, 63, 'ГОРОД САМАРА', 'УЛИЦА ВЛАДИМИРСКАЯ, Д', '443082'),
(1000000014, 78, 'САНКТ-ПЕТЕРБУРГ', 'НЕ УКАЗАНА', '196084'),
(1000000015, 59, 'М.О. ГУБАХИНСКИЙ, Г ГУБАХА', 'УЛ КРАСНООКТЯБРЬСКАЯ ДОМ 28', '618250'),
(1000000016, 32, 'Г. БРЯНСК', 'УЛ. БЕЛОБЕРЕЖСКАЯ ДОМ 26', '241004'),
(1000000018, 59, 'ПЕРМСКИЙ Р-Н, Д. КОНДРАТОВО', 'УЛ. САДОВОЕ КОЛЬЦО ДОМ 20, 5', '614506'),
(1000000019, 66, 'СВЕРДЛОВСКАЯ ОБЛ, Г ЕКАТЕРИНБУРГ', 'УЛ АКАДЕМИЧЕСКАЯ ДОМ 18, ОФИС 430', '620000'),
(1000000020, 91, 'Г. ФЕОДОСИЯ', 'УЛ. 8 МАРТА ДОМ 3', '298100'),
(1000000021, 72, 'ГОРОД ТЮМЕНЬ', 'УЛИЦА 30 ЛЕТ ПОБЕДЫ', '625007'),
(1000000022, 77, 'МОСКВА', 'АКАДЕМИКА КОРОЛЕВА 13, СТР. 1', '129515'),
(1000000023, 78, 'САНКТ-ПЕТЕРБУРГ', 'БУЛЬВАР СИРЕНЕВЫЙ 7, КОРП 1', '194352'),
(1200000000, 59, 'ПЕРМЬ', 'НЕ УКАЗАНА', '614000');

-- Банковские счета
INSERT INTO `bank_accounts` (`id_partner`, `bank_name`, `bik`, `account_number`, `currency`) VALUES
(1000000000, 'не использовать (ЮЛ ликвидировано)', '043510123', '702810000330000084', 'RUB'),
(1000000001, 'Филиал "Центральный" Банка ВТБ (ПАО) г.', '044525411', '702810118250001598', 'RUB'),
(1000000010, 'ПЕНЗЕНСКИЙ БАНК ПАО СБЕРБАНК (Расчетный)', '045655635', '702810148000005295', 'RUB'),
(1000000013, 'ПОВОЛЖСКИЙ БАНК ПАО СБЕРБАНК (Расчетный)', '043601607', '703810854400002272', 'RUB'),
(1000000014, 'ФИЛИАЛ ОПЕРУ ОАО БАНК ВТБ В САНКТ-ПЕТЕРБ', '044030704', '702810668000005457', 'RUB'),
(1000000015, 'Филиал "Центральный" Банка ВТБ (ПАО)', '042202603', '702810849770009162', 'RUB'),
(1000000018, 'Филиал "Центральный" Банка Тбанк(ПАО)', '044525201', '702810933100031047', 'RUB'),
(1000000019, 'не использовать (счет в банке закрыт)', '046577795', '702810163020000139', 'RUB'),
(1000000020, 'ФИЛИАЛ `ЕКАТЕРИНБУРГСКИЙ` АО `АЛЬФА-БАНК', '046577964', '702810038390000365', 'RUB'),
(1000000021, 'не использовать (ЮЛ ликвидировано)', '046577964', '702810238330000222', 'RUB');

-- Роли партнеров
INSERT INTO `partner_roles` (`id_partner`, `id_role_type`, `valid_from`) VALUES
(1000000000, 'CUS', '2020-12-01'), (1000000000, 'SUP', '2020-12-01'),
(1000000001, 'CUS', '2020-12-01'), (1000000001, 'SUP', '2020-12-01'),
(1000000010, 'CUS', '2020-12-01'), (1000000010, 'SUP', '2020-12-01'),
(1000000014, 'CUS', '2020-12-01'), (1000000014, 'SUP', '2020-12-01'),
(1000000019, 'SUP', '2020-12-01'), (1000000020, 'CUS', '2020-12-01'), 
(1000000022, 'SUP', '2020-12-01'), (1200000000, 'CUS', '2020-12-15');

-- Данные клиентов
INSERT INTO `customer_data` (`id_partner`, `sales_org`, `distr_channel`, `credit_limit`) VALUES
(1000000000, '1000', '01', 500000.00),
(1000000001, '1000', '01', 150000.00),
(1000000014, '1000', '01', 300000.00),
(1200000000, '1000', '01', 0.00);

-- Данные поставщиков
INSERT INTO `vendor_data` (`id_partner`, `purchasing_org`, `purchase_currency`, `vendor_rating`) VALUES
(1000000000, '1000', 'RUB', 4.50),
(1000000001, '2200', 'RUB', 4.20),
(1000000010, '1000', 'RUB', 3.80),
(1000000019, '1000', 'RUB', 4.90),
(1000000022, '2200', 'RUB', 5.00);

-- Журнал изменений
INSERT INTO `change_log` (`id_partner`, `change_date`, `change_type`, `initiator`, `description`) VALUES
(1000000000, '2020-12-10 18:48:07', 'Создание', 'TC_PO2S4H', 'Первичная загрузка данных из Excel'),
(1000000001, '2020-12-11 11:05:05', 'Создание', 'TC_PO2S4H', 'Первичная загрузка данных из Excel'),
(1000000014, '2020-12-14 20:18:58', 'Создание', 'TC_PO2S4H', 'Первичная загрузка данных из Excel'),
(1200000000, '2020-12-15 15:15:34', 'Создание', 'TC_PO2S4H', 'Первичная загрузка данных из Excel');


-- Изменение структуры
ALTER TABLE `business_partners` ADD COLUMN `email` VARCHAR(100) NULL AFTER `kpp`;

-- Обновление данных
UPDATE `business_partners` SET `email` = 'info@fason.ru' WHERE `id_partner` = 1000000000;
UPDATE `business_partners` SET `is_active` = 0 WHERE `id_partner` = 1000000001;

-- Удаление ошибочной записи (удаляем роль клиента у поставщика КУРСКСПЕЦОДЕЖДА)
DELETE FROM `partner_roles` WHERE `id_partner` = 1000000001 AND `id_role_type` = 'CUS';