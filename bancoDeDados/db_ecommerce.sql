-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 24-Jun-2021 às 19:52
-- Versão do servidor: 10.4.17-MariaDB
-- versão do PHP: 7.3.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `db_ecommerce`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_carts_save` (`pidcart` INT, `pdessessionid` VARCHAR(64), `piduser` INT, `pdeszipcode` CHAR(8), `pvlfreight` DECIMAL(10,2), `pnrdays` INT)  BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
  
    DECLARE vidperson INT;
    
  SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
    desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
  WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
    deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
  WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
  
    DECLARE vidperson INT;
    
  SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    DELETE FROM tb_users WHERE iduser = piduser;
    DELETE FROM tb_persons WHERE idperson = vidperson;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
  
    DECLARE vidperson INT;
    
  INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `nrzipcode` int(11) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_carts`
--

INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
(1, 'tfsv0si6oam53o9e5ctv5uisj6', NULL, NULL, NULL, NULL, '2021-03-23 17:04:58'),
(2, 'vok13pqfg59r27ip9giip4h214', NULL, NULL, NULL, NULL, '2021-03-23 17:06:09'),
(3, '434sc4r8vnk7c44ra01ogmh58i', 1, NULL, NULL, NULL, '2021-03-23 19:00:24'),
(4, 'hh344khpf06cht2t5i5f5d0m7r', NULL, NULL, NULL, NULL, '2021-03-24 17:20:37'),
(5, 'cd96sa4g1bqanr0sr53ialune2', NULL, NULL, NULL, NULL, '2021-03-25 03:05:38'),
(6, 'pb9re58v0q389qllnb48ilctb8', NULL, NULL, NULL, NULL, '2021-03-31 14:59:51'),
(7, 'pb9re58v0q389qllnb48ilctb8', NULL, '57060735', '109.92', 3, '2021-04-01 01:56:37'),
(8, 'pb9re58v0q389qllnb48ilctb8', NULL, '57060735', '109.92', 3, '2021-04-01 02:04:34'),
(9, 'pb9re58v0q389qllnb48ilctb8', NULL, '57060735', '109.92', 3, '2021-04-01 02:05:23'),
(10, 'pb9re58v0q389qllnb48ilctb8', NULL, '57060735', '162.45', 3, '2021-04-01 02:09:41'),
(11, 'al341kidic3smg72nqsech44be', NULL, NULL, NULL, NULL, '2021-04-01 02:12:03'),
(12, 'al341kidic3smg72nqsech44be', NULL, '57060735', '109.64', 3, '2021-04-01 02:12:30'),
(13, 'r4hum0op74757lillobt9t2d4k', NULL, NULL, NULL, NULL, '2021-04-01 02:20:09'),
(14, 'r4hum0op74757lillobt9t2d4k', NULL, '57060735', '124.70', 3, '2021-04-01 02:20:37'),
(15, 'f62jqhkv20ou6rqpio9t54sa6p', NULL, NULL, NULL, NULL, '2021-04-01 02:22:18'),
(16, 'f62jqhkv20ou6rqpio9t54sa6p', NULL, '57060735', '109.64', 3, '2021-04-01 02:22:45'),
(17, '7o8hpcisvkelg4nbo7mpkf6j88', NULL, NULL, NULL, NULL, '2021-04-01 02:25:30'),
(18, '7o8hpcisvkelg4nbo7mpkf6j88', NULL, '57060735', '124.70', 3, '2021-04-01 02:25:56'),
(19, '7o8hpcisvkelg4nbo7mpkf6j88', NULL, '57060735', '162.45', 3, '2021-04-01 02:27:52'),
(20, '7o8hpcisvkelg4nbo7mpkf6j88', NULL, '57084082', '142.00', 3, '2021-04-01 02:36:25'),
(21, '4rsedjnvcv3kj7jhvblvdhcpam', NULL, NULL, NULL, NULL, '2021-04-01 14:49:04'),
(22, 'gnvca7o2mp6uui1h4b8qlsccil', NULL, NULL, NULL, NULL, '2021-04-01 15:00:19'),
(23, 'gnvca7o2mp6uui1h4b8qlsccil', NULL, '57037035', '100.54', 3, '2021-04-01 15:21:54'),
(24, 'j7078i8k2attvuu9vi490anf97', NULL, NULL, NULL, NULL, '2021-04-01 15:23:01'),
(25, 'j7078i8k2attvuu9vi490anf97', NULL, '57037035', '124.70', 3, '2021-04-01 15:23:46'),
(26, 'nqhll78fo9ucpbodk2gj1t8k5k', NULL, NULL, NULL, NULL, '2021-04-01 15:26:14'),
(27, '9cqmmvp485oqhhnq0ruh5h4bgr', NULL, NULL, NULL, NULL, '2021-04-01 15:26:55'),
(28, '9cqmmvp485oqhhnq0ruh5h4bgr', NULL, '57037035', '124.70', 3, '2021-04-01 15:28:48'),
(29, '9cqmmvp485oqhhnq0ruh5h4bgr', NULL, '57037035', '100.54', 3, '2021-04-01 18:21:35'),
(30, '9cqmmvp485oqhhnq0ruh5h4bgr', NULL, '57048724', '124.70', 3, '2021-04-01 20:31:25'),
(31, '8qj01a3edjf120s30pqh2hirdd', NULL, NULL, NULL, NULL, '2021-04-02 16:43:05'),
(32, 'e4v488ceqj757f34n8uu1ertf4', NULL, NULL, NULL, NULL, '2021-04-04 03:56:34'),
(33, '68asq17tqsi54c265c20sj1fmn', NULL, NULL, NULL, NULL, '2021-04-04 18:16:09'),
(34, '9hsneuv6va433pde1c9ljet9fs', NULL, NULL, NULL, NULL, '2021-04-05 17:29:40'),
(35, '9hsneuv6va433pde1c9ljet9fs', NULL, '57018574', '124.70', 3, '2021-04-05 17:44:53'),
(36, '9hsneuv6va433pde1c9ljet9fs', NULL, '57018574', '124.70', 3, '2021-04-05 18:10:26'),
(37, '9hsneuv6va433pde1c9ljet9fs', NULL, '57018574', '124.70', 3, '2021-04-05 18:16:12'),
(38, '9hsneuv6va433pde1c9ljet9fs', NULL, '57018574', '124.70', 3, '2021-04-05 18:25:11'),
(39, '9hsneuv6va433pde1c9ljet9fs', NULL, '57018574', '162.45', 3, '2021-04-05 18:29:25'),
(40, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, NULL, NULL, NULL, '2021-04-05 18:30:40'),
(41, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, '57018574', '138.45', 3, '2021-04-05 18:31:23'),
(42, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, '57018574', '138.45', 3, '2021-04-05 18:40:50'),
(43, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, '57018574', '138.45', 3, '2021-04-05 18:45:36'),
(44, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, '57018574', '138.45', 3, '2021-04-05 18:47:20'),
(45, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, '57018574', '138.45', 3, '2021-04-05 18:47:41'),
(46, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, '57018574', '138.45', 3, '2021-04-05 18:48:44'),
(47, 'jd2gjfhk94rogr0oftcofcdcfb', NULL, '57018574', '138.45', 3, '2021-04-05 18:49:32'),
(48, 're5hov2eu5jubcpceoe45c8fb6', NULL, NULL, NULL, NULL, '2021-04-06 19:24:38'),
(49, 're5hov2eu5jubcpceoe45c8fb6', NULL, '57020065', '112.92', 4, '2021-04-06 19:55:11'),
(50, 're5hov2eu5jubcpceoe45c8fb6', NULL, '57020065', '145.00', 4, '2021-04-06 22:04:28'),
(51, 'j5ck4fsgi4or5qvubni39hj7ue', NULL, NULL, NULL, NULL, '2021-04-07 15:04:34'),
(52, 'j5ck4fsgi4or5qvubni39hj7ue', NULL, '57044020', '124.70', 3, '2021-04-07 15:06:51'),
(53, 'j5ck4fsgi4or5qvubni39hj7ue', NULL, '57044020', '147.40', 3, '2021-04-07 18:26:54'),
(54, '8i1l8r24127vok5v2c6pmj4j85', NULL, NULL, NULL, NULL, '2021-04-09 15:33:01'),
(55, '8i1l8r24127vok5v2c6pmj4j85', NULL, '41185555', '85.24', 2, '2021-04-09 15:36:09'),
(56, '4lajf9vdutmv8k6r30h8qir86j', NULL, NULL, NULL, NULL, '2021-04-16 19:31:37'),
(57, '4lajf9vdutmv8k6r30h8qir86j', NULL, '57073021', '124.70', 3, '2021-04-16 19:48:39'),
(58, '4lajf9vdutmv8k6r30h8qir86j', NULL, '57074422', '162.45', 3, '2021-04-16 19:54:51'),
(59, 'p0t8sr7bbcponan63l4fvtgl46', NULL, NULL, NULL, NULL, '2021-06-05 18:11:18'),
(60, '4br1u40sdkjpiq62vpjnlvvbfu', NULL, NULL, NULL, NULL, '2021-06-22 16:28:52'),
(61, '6afgc8bjccgm9h3j82d7pp9152', 1, NULL, NULL, NULL, '2021-06-22 17:36:54'),
(62, '6afgc8bjccgm9h3j82d7pp9152', 1, '57074422', '124.69', 3, '2021-06-22 17:38:52'),
(63, 'idfhlh6r1bkbv69bnhoq4lspf5', NULL, NULL, NULL, NULL, '2021-06-22 19:44:02'),
(64, 'idfhlh6r1bkbv69bnhoq4lspf5', NULL, '41185555', '76.13', 2, '2021-06-22 19:59:56'),
(65, 'idfhlh6r1bkbv69bnhoq4lspf5', NULL, '41185555', '202.50', 2, '2021-06-22 21:46:19'),
(66, 'idfhlh6r1bkbv69bnhoq4lspf5', NULL, '41185555', '179.80', 2, '2021-06-23 16:28:02'),
(67, 'rg11t0s78l3sq27vfutokkbhov', NULL, NULL, NULL, NULL, '2021-06-23 16:29:53'),
(68, 'idfhlh6r1bkbv69bnhoq4lspf5', NULL, '41185555', '100.29', 2, '2021-06-23 16:30:21'),
(69, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '124.69', 3, '2021-06-23 16:31:04'),
(70, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '162.44', 3, '2021-06-23 16:31:42'),
(71, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '190.40', 3, '2021-06-23 16:35:50'),
(72, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '133.82', 3, '2021-06-23 16:38:11'),
(73, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '124.69', 3, '2021-06-23 16:40:32'),
(74, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '124.69', 3, '2021-06-23 16:41:03'),
(75, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '124.69', 3, '2021-06-23 16:43:56'),
(76, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57020065', '109.91', 3, '2021-06-23 16:45:20'),
(77, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '109.91', 3, '2021-06-23 16:45:27'),
(78, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57074422', '109.63', 3, '2021-06-23 16:49:47'),
(79, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57018574', '109.63', 3, '2021-06-23 16:51:05'),
(80, 'rg11t0s78l3sq27vfutokkbhov', NULL, '57018574', '124.69', 3, '2021-06-23 16:51:52'),
(81, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, NULL, NULL, NULL, '2021-06-23 16:55:01'),
(82, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57020065', '124.69', 3, '2021-06-23 16:55:47'),
(83, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57020065', '124.69', 3, '2021-06-23 16:55:56'),
(84, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57020065', '109.63', 3, '2021-06-23 16:59:54'),
(85, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57020065', '138.99', 3, '2021-06-23 17:00:45'),
(86, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57020065', '124.69', 3, '2021-06-23 17:01:54'),
(87, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57060735', '112.91', 3, '2021-06-23 17:03:09'),
(88, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57060735', '109.63', 3, '2021-06-23 17:04:26'),
(89, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57060735', '124.69', 3, '2021-06-23 17:05:14'),
(90, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57060735', '472.94', 3, '2021-06-23 17:15:27'),
(91, 'n7jhm7nstpovi9fqok99gjmpdg', NULL, '57060735', '360.81', 3, '2021-06-23 17:22:06'),
(92, 'rpuvj8utk1evdig7c52t22cqla', NULL, NULL, NULL, NULL, '2021-06-23 17:24:11'),
(93, 'vok13pqfg59r27ip9giip4h214', NULL, '57084082', '138.28', 3, '2021-06-23 17:24:34'),
(94, 'vok13pqfg59r27ip9giip4h214', NULL, '57084082', '446.70', 3, '2021-06-23 17:34:08'),
(95, 'rpuvj8utk1evdig7c52t22cqla', NULL, '57084082', '124.69', 3, '2021-06-23 17:36:52'),
(96, 'rpuvj8utk1evdig7c52t22cqla', NULL, '57084082', '360.81', 3, '2021-06-23 18:01:36'),
(97, 'rpuvj8utk1evdig7c52t22cqla', NULL, '13450357', '303.71', 1, '2021-06-23 18:05:37'),
(98, 'rpuvj8utk1evdig7c52t22cqla', NULL, '13450357', '72.19', 1, '2021-06-23 18:06:27'),
(99, 'rpuvj8utk1evdig7c52t22cqla', NULL, '13450357', '72.19', 1, '2021-06-23 18:08:47'),
(100, 'rpuvj8utk1evdig7c52t22cqla', NULL, '13450357', '186.95', 1, '2021-06-23 18:10:21'),
(101, 'j5ck4fsgi4or5qvubni39hj7ue', NULL, '13450357', '94.89', 1, '2021-06-23 18:16:37'),
(102, 'jrcirpf5ubm2uo11vacainaqk2', NULL, NULL, NULL, NULL, '2021-06-23 18:20:37'),
(103, 'j5ck4fsgi4or5qvubni39hj7ue', NULL, '57044020', '109.63', 3, '2021-06-23 18:21:03'),
(104, 'j5ck4fsgi4or5qvubni39hj7ue', NULL, '57060735', '109.63', 3, '2021-06-23 18:34:57'),
(105, 'jrcirpf5ubm2uo11vacainaqk2', NULL, '57060735', '100.53', 3, '2021-06-23 18:38:21'),
(106, '3b6ubrss13giacddmhlm511kr3', NULL, NULL, NULL, NULL, '2021-06-23 19:01:17'),
(107, '3b6ubrss13giacddmhlm511kr3', NULL, '05851160', '72.19', 6, '2021-06-23 19:01:33'),
(108, 'aenhfp453rfbtcmqr3a594o02k', NULL, NULL, NULL, NULL, '2021-06-23 19:20:45'),
(109, 'aenhfp453rfbtcmqr3a594o02k', NULL, '07853050', '57.13', 1, '2021-06-23 19:22:35'),
(110, 'aenhfp453rfbtcmqr3a594o02k', NULL, '07853050', '57.13', 1, '2021-06-23 19:30:59'),
(111, 'aenhfp453rfbtcmqr3a594o02k', NULL, '07853050', '57.13', 1, '2021-06-24 00:46:34'),
(112, 'vok13pqfg59r27ip9giip4h214', NULL, '07853050', '109.94', 1, '2021-06-24 00:48:24'),
(113, 'aenhfp453rfbtcmqr3a594o02k', NULL, '07853050', '84.61', 1, '2021-06-24 00:49:35'),
(114, 'aenhfp453rfbtcmqr3a594o02k', NULL, '07853050', '288.08', 1, '2021-06-24 00:53:35'),
(115, 'aenhfp453rfbtcmqr3a594o02k', NULL, '07853050', '133.30', 1, '2021-06-24 00:54:50'),
(116, 'rplt2rsampaa0rdk7sbfmhr2ch', NULL, NULL, NULL, NULL, '2021-06-24 01:03:05'),
(117, 'rplt2rsampaa0rdk7sbfmhr2ch', NULL, '13806685', '57.13', 2, '2021-06-24 01:03:44'),
(118, 'gqmbalei1hhn96lm1ruddrs36e', NULL, NULL, NULL, NULL, '2021-06-24 16:14:40'),
(119, 'vok13pqfg59r27ip9giip4h214', NULL, '57060735', '123.23', 5, '2021-06-24 16:19:24'),
(120, 'vok13pqfg59r27ip9giip4h214', NULL, '57060735', '165.64', 5, '2021-06-24 16:55:42'),
(121, 'gqmbalei1hhn96lm1ruddrs36e', NULL, '13806685', '72.19', 5, '2021-06-24 17:21:58');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_cartsproducts`
--

INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
(1, 3, 12, '0000-00-00 00:00:00', '2021-03-24 02:49:43'),
(2, 3, 12, '0000-00-00 00:00:00', '2021-03-24 02:51:27'),
(3, 3, 12, '0000-00-00 00:00:00', '2021-03-24 02:57:52'),
(4, 3, 12, '0000-00-00 00:00:00', '2021-03-24 02:58:27'),
(5, 3, 11, '0000-00-00 00:00:00', '2021-03-24 02:59:56'),
(6, 3, 12, '2021-03-24 00:31:34', '2021-03-24 03:03:13'),
(7, 3, 11, '2021-03-24 00:36:26', '2021-03-24 03:05:24'),
(8, 3, 12, '2021-03-24 00:35:35', '2021-03-24 03:09:16'),
(9, 3, 12, '2021-03-24 00:35:42', '2021-03-24 03:13:16'),
(10, 3, 12, '2021-03-24 00:35:42', '2021-03-24 03:30:10'),
(11, 3, 12, '2021-03-24 00:35:42', '2021-03-24 03:35:37'),
(12, 3, 15, '2021-03-24 00:36:54', '2021-03-24 03:36:50'),
(13, 3, 12, '2021-03-24 00:37:44', '2021-03-24 03:37:35'),
(14, 3, 12, '2021-03-24 00:44:53', '2021-03-24 03:42:34'),
(15, 3, 12, '2021-03-24 00:44:53', '2021-03-24 03:43:27'),
(16, 3, 12, '2021-03-24 00:44:53', '2021-03-24 03:43:32'),
(17, 3, 11, '2021-03-24 00:55:17', '2021-03-24 03:48:50'),
(18, 3, 11, '2021-03-24 00:55:17', '2021-03-24 03:48:50'),
(19, 3, 11, '2021-03-24 00:55:17', '2021-03-24 03:48:50'),
(20, 3, 12, '2021-03-24 00:55:16', '2021-03-24 03:49:07'),
(21, 3, 13, '2021-03-24 00:55:18', '2021-03-24 03:52:06'),
(22, 3, 13, '2021-03-24 00:55:18', '2021-03-24 03:52:19'),
(23, 3, 13, '2021-03-24 00:55:18', '2021-03-24 03:52:20'),
(24, 3, 13, '2021-03-24 00:55:18', '2021-03-24 03:52:20'),
(25, 3, 13, '2021-03-24 00:55:18', '2021-03-24 03:52:20'),
(26, 3, 11, '2021-03-24 00:55:17', '2021-03-24 03:52:41'),
(27, 3, 11, '2021-03-24 00:55:17', '2021-03-24 03:52:45'),
(28, 3, 12, '2021-03-24 00:55:16', '2021-03-24 03:52:47'),
(29, 3, 12, '2021-03-24 00:55:16', '2021-03-24 03:52:48'),
(30, 3, 12, '2021-03-24 00:55:16', '2021-03-24 03:52:49'),
(31, 3, 12, '2021-03-24 00:55:16', '2021-03-24 03:52:50'),
(32, 4, 15, '2021-03-24 15:05:35', '2021-03-24 18:05:30'),
(33, 5, 14, '2021-03-25 00:05:52', '2021-03-25 03:05:38'),
(34, 5, 14, '2021-03-25 00:05:52', '2021-03-25 03:05:38'),
(35, 5, 14, '2021-03-25 00:05:52', '2021-03-25 03:05:38'),
(36, 5, 14, '2021-03-25 00:05:52', '2021-03-25 03:05:38'),
(37, 5, 14, '2021-03-25 00:05:52', '2021-03-25 03:05:38'),
(38, 6, 11, '2021-03-31 13:44:45', '2021-03-31 16:23:01'),
(39, 6, 11, '2021-03-31 13:44:45', '2021-03-31 16:23:04'),
(40, 6, 12, '2021-03-31 13:44:43', '2021-03-31 16:25:36'),
(41, 6, 15, '2021-03-31 14:16:23', '2021-03-31 16:44:51'),
(42, 6, 15, '2021-03-31 14:16:23', '2021-03-31 16:44:54'),
(43, 6, 12, '2021-03-31 16:22:40', '2021-03-31 19:22:37'),
(44, 6, 12, '2021-03-31 16:31:24', '2021-03-31 19:22:39'),
(45, 6, 12, '2021-03-31 16:31:25', '2021-03-31 19:31:09'),
(46, 6, 12, '2021-03-31 21:01:14', '2021-03-31 19:31:10'),
(47, 6, 15, '2021-03-31 16:37:23', '2021-03-31 19:37:08'),
(48, 6, 14, '2021-03-31 23:08:37', '2021-03-31 21:34:18'),
(49, 6, 12, NULL, '2021-04-01 02:08:45'),
(50, 6, 12, NULL, '2021-04-01 02:09:23'),
(51, 11, 11, NULL, '2021-04-01 02:12:19'),
(52, 13, 12, '2021-03-31 23:21:39', '2021-04-01 02:20:27'),
(53, 13, 15, NULL, '2021-04-01 02:21:54'),
(54, 15, 11, '2021-03-31 23:24:51', '2021-04-01 02:22:18'),
(55, 17, 12, '2021-03-31 23:32:08', '2021-04-01 02:25:30'),
(56, 17, 12, '2021-03-31 23:32:08', '2021-04-01 02:27:35'),
(57, 17, 14, NULL, '2021-04-01 02:32:16'),
(58, 17, 13, '2021-03-31 23:41:33', '2021-04-01 02:35:03'),
(59, 22, 15, NULL, '2021-04-01 15:00:19'),
(60, 24, 12, NULL, '2021-04-01 15:23:40'),
(61, 27, 12, '2021-04-01 15:20:18', '2021-04-01 15:26:55'),
(62, 27, 15, '2021-04-01 17:26:07', '2021-04-01 18:20:25'),
(63, 27, 15, '2021-04-01 17:26:08', '2021-04-01 20:25:51'),
(64, 27, 15, '2021-04-01 17:29:28', '2021-04-01 20:25:53'),
(65, 27, 12, '2021-04-01 17:26:56', '2021-04-01 20:26:24'),
(66, 27, 15, '2021-04-01 17:29:30', '2021-04-01 20:26:43'),
(67, 27, 12, NULL, '2021-04-01 20:26:44'),
(68, 31, 12, '2021-04-02 21:21:48', '2021-04-02 16:45:37'),
(69, 31, 14, '2021-04-02 21:21:51', '2021-04-02 16:45:47'),
(70, 31, 14, '2021-04-02 21:23:03', '2021-04-03 00:16:20'),
(71, 31, 12, '2021-04-02 21:23:01', '2021-04-03 00:16:22'),
(72, 31, 11, NULL, '2021-04-03 00:20:56'),
(73, 34, 12, NULL, '2021-04-05 17:29:40'),
(74, 34, 12, NULL, '2021-04-05 18:25:38'),
(75, 40, 11, NULL, '2021-04-05 18:31:13'),
(76, 40, 11, NULL, '2021-04-05 18:31:16'),
(77, 48, 13, NULL, '2021-04-06 19:24:38'),
(78, 48, 13, NULL, '2021-04-06 22:04:23'),
(79, 51, 12, NULL, '2021-04-07 15:05:41'),
(80, 51, 11, NULL, '2021-04-07 18:26:01'),
(81, 54, 11, NULL, '2021-04-09 15:33:01'),
(82, 56, 12, NULL, '2021-04-16 19:31:37'),
(83, 56, 12, NULL, '2021-04-16 19:53:57'),
(84, 59, 12, NULL, '2021-06-05 18:11:18'),
(85, 60, 11, NULL, '2021-06-22 16:28:52'),
(86, 61, 12, '2021-06-22 14:38:08', '2021-06-22 17:37:10'),
(87, 61, 12, NULL, '2021-06-22 17:38:06'),
(88, 61, 11, NULL, '2021-06-22 19:41:22'),
(89, 63, 15, '2021-06-22 16:59:06', '2021-06-22 19:44:02'),
(90, 63, 15, NULL, '2021-06-22 19:44:33'),
(91, 64, 12, NULL, '2021-06-22 21:45:22'),
(92, 64, 12, NULL, '2021-06-22 21:45:25'),
(93, 64, 12, NULL, '2021-06-22 21:45:25'),
(94, 64, 11, NULL, '2021-06-22 21:45:45'),
(95, 65, 12, '2021-06-22 18:55:00', '2021-06-22 21:52:33'),
(96, 65, 12, '2021-06-22 20:55:26', '2021-06-22 23:55:21'),
(97, 65, 12, '2021-06-22 21:01:36', '2021-06-22 23:55:24'),
(98, 65, 12, NULL, '2021-06-23 00:01:34'),
(99, 65, 12, NULL, '2021-06-23 16:27:55'),
(100, 65, 12, NULL, '2021-06-23 16:27:58'),
(101, 66, 12, NULL, '2021-06-23 16:30:16'),
(102, 67, 12, NULL, '2021-06-23 16:30:48'),
(103, 69, 12, NULL, '2021-06-23 16:31:33'),
(104, 69, 12, NULL, '2021-06-23 16:31:34'),
(105, 70, 13, NULL, '2021-06-23 16:35:33'),
(106, 70, 11, NULL, '2021-06-23 16:35:43'),
(107, 70, 13, NULL, '2021-06-23 16:35:46'),
(108, 70, 11, NULL, '2021-06-23 16:35:48'),
(109, 71, 15, NULL, '2021-06-23 16:38:02'),
(110, 71, 15, NULL, '2021-06-23 16:38:05'),
(111, 71, 15, NULL, '2021-06-23 16:38:06'),
(112, 74, 12, NULL, '2021-06-23 16:43:53'),
(113, 75, 14, NULL, '2021-06-23 16:45:05'),
(114, 77, 11, NULL, '2021-06-23 16:49:42'),
(115, 78, 11, NULL, '2021-06-23 16:51:00'),
(116, 79, 12, NULL, '2021-06-23 16:51:48'),
(117, 81, 12, NULL, '2021-06-23 16:55:01'),
(118, 2, 15, '2021-06-23 21:48:17', '2021-06-23 16:55:12'),
(119, 2, 12, '2021-06-24 13:15:13', '2021-06-23 16:55:20'),
(120, 42, 12, NULL, '2021-06-23 16:58:10'),
(121, 83, 11, NULL, '2021-06-23 16:59:50'),
(122, 84, 14, NULL, '2021-06-23 17:00:39'),
(123, 84, 14, NULL, '2021-06-23 17:00:42'),
(124, 85, 12, NULL, '2021-06-23 17:01:52'),
(125, 86, 13, NULL, '2021-06-23 17:02:55'),
(126, 87, 11, NULL, '2021-06-23 17:04:22'),
(127, 88, 12, NULL, '2021-06-23 17:05:11'),
(128, 89, 11, NULL, '2021-06-23 17:13:52'),
(129, 89, 15, NULL, '2021-06-23 17:14:07'),
(130, 89, 15, NULL, '2021-06-23 17:14:42'),
(131, 89, 11, NULL, '2021-06-23 17:14:44'),
(132, 89, 11, NULL, '2021-06-23 17:14:47'),
(133, 89, 15, NULL, '2021-06-23 17:14:49'),
(134, 90, 12, NULL, '2021-06-23 17:21:56'),
(135, 90, 12, NULL, '2021-06-23 17:21:59'),
(136, 90, 12, NULL, '2021-06-23 17:21:59'),
(137, 90, 12, NULL, '2021-06-23 17:22:00'),
(138, 90, 12, NULL, '2021-06-23 17:22:01'),
(139, 92, 15, '2021-06-23 14:36:38', '2021-06-23 17:24:11'),
(140, 93, 15, NULL, '2021-06-23 17:33:38'),
(141, 93, 12, NULL, '2021-06-23 17:33:44'),
(142, 93, 14, NULL, '2021-06-23 17:33:53'),
(143, 93, 14, NULL, '2021-06-23 17:33:59'),
(144, 93, 15, NULL, '2021-06-23 17:34:01'),
(145, 93, 12, NULL, '2021-06-23 17:34:02'),
(146, 92, 12, '2021-06-23 15:06:20', '2021-06-23 17:36:44'),
(147, 92, 12, '2021-06-23 15:06:21', '2021-06-23 17:59:54'),
(148, 48, 15, NULL, '2021-06-23 18:00:20'),
(149, 92, 12, '2021-06-23 15:06:22', '2021-06-23 18:01:20'),
(150, 92, 12, '2021-06-23 15:06:23', '2021-06-23 18:01:21'),
(151, 92, 12, NULL, '2021-06-23 18:01:22'),
(152, 96, 13, NULL, '2021-06-23 18:03:47'),
(153, 92, 12, NULL, '2021-06-23 18:10:13'),
(154, 92, 12, NULL, '2021-06-23 18:10:14'),
(155, 92, 12, NULL, '2021-06-23 18:10:15'),
(156, 52, 11, NULL, '2021-06-23 18:20:49'),
(157, 102, 15, '2021-06-23 16:00:21', '2021-06-23 18:38:13'),
(158, 106, 12, NULL, '2021-06-23 19:01:17'),
(159, 108, 11, '2021-06-23 21:42:58', '2021-06-23 19:20:45'),
(160, 108, 14, '2021-06-23 19:25:02', '2021-06-23 19:49:02'),
(161, 108, 11, '2021-06-23 21:54:45', '2021-06-24 00:42:55'),
(162, 2, 12, '2021-06-24 13:15:13', '2021-06-24 00:48:20'),
(163, 108, 13, '2021-06-23 21:54:44', '2021-06-24 00:49:30'),
(164, 108, 11, NULL, '2021-06-24 00:53:26'),
(165, 108, 11, NULL, '2021-06-24 00:53:28'),
(166, 108, 13, NULL, '2021-06-24 00:53:29'),
(167, 108, 13, NULL, '2021-06-24 00:53:30'),
(168, 116, 11, NULL, '2021-06-24 01:03:39'),
(169, 117, 15, NULL, '2021-06-24 02:18:27'),
(170, 2, 11, NULL, '2021-06-24 16:15:19'),
(171, 2, 15, NULL, '2021-06-24 16:15:31'),
(172, 118, 12, NULL, '2021-06-24 16:45:33'),
(173, 119, 11, NULL, '2021-06-24 16:50:54'),
(174, 119, 15, NULL, '2021-06-24 16:55:18'),
(175, 119, 15, NULL, '2021-06-24 16:55:20'),
(176, 119, 11, NULL, '2021-06-24 16:55:21');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(1, 'Android', '2021-02-11 17:36:44'),
(8, 'Motorola', '2021-02-12 00:33:16'),
(9, 'Apple', '2021-02-12 00:33:23'),
(10, 'Samsung', '2021-02-12 00:33:32');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_categoriesproducts`
--

CREATE TABLE `tb_categoriesproducts` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_categoriesproducts`
--

INSERT INTO `tb_categoriesproducts` (`idcategory`, `idproduct`) VALUES
(1, 12);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 06:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 06:00:00'),
(3, 'Pago', '2017-03-13 06:00:00'),
(4, 'Entregue', '2017-03-13 06:00:00');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(1, 'Joao Rangel', 'admin@hcode.com.br', 2147483647, '2017-03-01 06:00:00'),
(7, 'Suporte', 'suporte@hcode.com.br', 1112345678, '2017-03-15 19:10:27'),
(21, 'Alberto Einstein', 'luizpaulopds@outlook.com.br', 1112345678, '2021-02-05 01:42:49'),
(28, 'Novo Usuario', 'luizpaulopds@hotmail.com', 11, '2021-02-06 21:21:11');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(11, 'Smartphone Motorola Moto G5 Plus', '1135.23', '15.20', '7.40', '0.70', '0.16', 'smartphone-motorola-moto-g5-plus', '2021-03-13 18:40:53'),
(12, 'Smartphone Moto Z Play', '1887.78', '14.10', '0.90', '1.16', '0.13', 'smartphone-moto-z-play', '2021-03-13 18:40:53'),
(13, 'Smartphone Samsung Galaxy J5 Pro', '1299.00', '14.60', '7.10', '0.80', '0.16', 'smartphone-samsung-galaxy-j5', '2021-03-13 18:40:53'),
(14, 'Smartphone Samsung Galaxy J7 Prime', '1149.00', '15.10', '7.50', '0.80', '0.16', 'smartphone-samsung-galaxy-j7', '2021-03-13 18:40:53'),
(15, 'Smartphone Samsung Galaxy J3 Dual', '679.90', '14.20', '7.10', '0.70', '0.14', 'smartphone-samsung-galaxy-j3', '2021-03-13 18:40:53');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(8, 11),
(8, 12),
(10, 13),
(10, 14),
(10, 15);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT 0,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(1, 1, 'admin', '$2y$12$YlooCyNvyTji8bPRcrfNfOKnVMmZA9ViM2A3IpFjmrpIbp5ovNmga', 1, '2017-03-13 06:00:00'),
(7, 7, 'suporte', '$2y$12$HFjgUm/mk1RzTy4ZkJaZBe0Mc/BA2hQyoUckvm.lFa6TesjtNpiMe', 1, '2017-03-15 19:10:27'),
(21, 21, 'alberto', '$2y$12$FsVaehd1MW3YecuF6f.rruBgvPTPgjw2MEydHooqHbjAbD8JWInUa', 1, '2021-02-05 01:42:49'),
(28, 28, 'novo', '$2y$12$k7B3nViedO0SRlixUeDn5eP9MyGkqzw/XjnBo3ukymzZadRM3TVj2', 1, '2021-02-06 21:21:12');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 19:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 19:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 19:37:12'),
(4, 21, '::1', NULL, '2021-02-05 02:01:46'),
(5, 21, '::1', NULL, '2021-02-05 02:03:02'),
(6, 21, '::1', NULL, '2021-02-05 02:15:21'),
(7, 21, '::1', NULL, '2021-02-05 02:44:47'),
(8, 21, '::1', NULL, '2021-02-05 02:45:19'),
(9, 21, '::1', NULL, '2021-02-05 02:46:10'),
(10, 21, '::1', NULL, '2021-02-05 02:50:04'),
(11, 21, '::1', NULL, '2021-02-05 03:03:47'),
(12, 21, '::1', NULL, '2021-02-05 03:03:55'),
(13, 21, '::1', NULL, '2021-02-05 03:04:24'),
(14, 21, '::1', NULL, '2021-02-05 03:10:58'),
(15, 21, '::1', NULL, '2021-02-05 03:12:50'),
(16, 21, '::1', NULL, '2021-02-05 03:13:29'),
(17, 21, '::1', NULL, '2021-02-05 03:21:32'),
(18, 21, '::1', NULL, '2021-02-05 03:32:40'),
(19, 21, '::1', NULL, '2021-02-05 03:38:59'),
(20, 21, '::1', NULL, '2021-02-05 03:40:34'),
(21, 21, '::1', NULL, '2021-02-05 03:41:50'),
(22, 21, '::1', NULL, '2021-02-05 03:43:56'),
(23, 21, '::1', NULL, '2021-02-05 03:44:59'),
(24, 21, '::1', NULL, '2021-02-05 03:55:33'),
(25, 21, '::1', NULL, '2021-02-05 03:56:15'),
(26, 21, '::1', NULL, '2021-02-05 15:53:34'),
(27, 21, '::1', NULL, '2021-02-05 15:55:20'),
(28, 21, '::1', NULL, '2021-02-05 15:56:10'),
(29, 21, '::1', NULL, '2021-02-05 15:57:05'),
(30, 21, '::1', NULL, '2021-02-05 16:52:39'),
(31, 21, '::1', NULL, '2021-02-05 16:53:21'),
(32, 21, '::1', NULL, '2021-02-05 16:53:42'),
(33, 21, '::1', NULL, '2021-02-05 16:57:23'),
(34, 21, '::1', NULL, '2021-02-05 16:57:53'),
(35, 21, '::1', NULL, '2021-02-05 16:58:58'),
(36, 21, '::1', NULL, '2021-02-05 17:00:32'),
(37, 21, '::1', NULL, '2021-02-05 20:12:38'),
(38, 21, '::1', NULL, '2021-02-05 20:13:10'),
(39, 21, '::1', NULL, '2021-02-05 20:36:18'),
(40, 21, '::1', NULL, '2021-02-06 20:01:31'),
(41, 28, '::1', NULL, '2021-02-06 21:21:50'),
(42, 28, '::1', NULL, '2021-02-06 21:54:49'),
(43, 28, '::1', NULL, '2021-02-07 02:31:10'),
(44, 28, '::1', NULL, '2021-02-07 02:41:46'),
(45, 28, '::1', NULL, '2021-02-07 02:55:13'),
(46, 28, '::1', NULL, '2021-02-07 19:07:12'),
(47, 28, '::1', NULL, '2021-02-07 21:41:01'),
(48, 28, '::1', NULL, '2021-02-07 21:42:15'),
(49, 28, '::1', NULL, '2021-02-07 21:44:03'),
(50, 28, '::1', NULL, '2021-02-07 21:47:35'),
(51, 28, '::1', '2021-02-07 19:06:20', '2021-02-07 21:49:56'),
(52, 28, '::1', '2021-02-08 16:52:35', '2021-02-08 19:39:24'),
(53, 21, '::1', '2021-02-08 17:13:49', '2021-02-08 20:07:05'),
(54, 28, '::1', '2021-02-08 17:38:20', '2021-02-08 20:30:03'),
(55, 21, '::1', '2021-02-09 15:25:35', '2021-02-09 18:22:58'),
(56, 28, '::1', '2021-02-09 15:29:52', '2021-02-09 18:26:53'),
(57, 21, '::1', NULL, '2021-02-15 01:38:10');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Índices para tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`);

--
-- Índices para tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `FK_cartsproducts_products_idx` (`idproduct`);

--
-- Índices para tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Índices para tabela `tb_categoriesproducts`
--
ALTER TABLE `tb_categoriesproducts`
  ADD PRIMARY KEY (`idcategory`,`idproduct`);

--
-- Índices para tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_carts_idx` (`idcart`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`);

--
-- Índices para tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Índices para tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Índices para tabela `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Índices para tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Índices para tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Índices para tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Índices para tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  MODIFY `idcart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;

--
-- AUTO_INCREMENT de tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=177;

--
-- AUTO_INCREMENT de tabela `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de tabela `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de tabela `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
