-- phpMyAdmin SQL Dump
-- version 5.2.3-1.el10_0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 29/06/2026 às 20:17
-- Versão do servidor: 10.11.15-MariaDB
-- Versão do PHP: 8.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `todimoti`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `filiais`
--

CREATE TABLE `filiais` (
  `id` int(10) NOT NULL,
  `filial` varchar(5) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `telefone` varchar(30) NOT NULL,
  `circuito_tel` varchar(50) NOT NULL,
  `circuito_dados` varchar(50) NOT NULL,
  `circuito_dados2` varchar(50) NOT NULL,
  `cnpj` varchar(20) NOT NULL,
  `cidade` varchar(50) NOT NULL,
  `estado` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Despejando dados para a tabela `filiais`
--

INSERT INTO `filiais` (`id`, `filial`, `nome`, `telefone`, `circuito_tel`, `circuito_dados`, `circuito_dados2`, `cnpj`, `cidade`, `estado`) VALUES
(1, '08', 'TIRADENTES', '43 3375-5500', '4333755500 (EMBRATEL)', ' LDA/IP/01987 (100MB)', 'SPO0439494 (OI 50MB)', '15.375.991/0010-55', 'LONDRINA', 'PR'),
(3, '11', 'CINCO CONJUNTOS', '43 3372-5000', '4333725000 (EMBRATEL)', 'LDA/IP/01986 (50MB)', 'LP 413610178295895 (VIVO 50MB)', '15.375.991/0012-17', 'LONDRINA', 'PR'),
(4, '27', 'CAMBÉ', '43 3711-1930', '4337111930 (EMBRATEL)', 'CAB/IP/00388 (50MB)', 'ID 2014088 (VIVO 50MB)', '15.375.991/0028-84', 'CAMBÉ', 'PR'),
(5, '07', 'CD-PR', '43 3376-5500', 'CTA0530545 (OI)', 'LDA/IP/01988 (100MB)', 'LP 413610178291199 (VIVO 50MB)', '15.375.991/0009-11', 'LONDRINA', 'PR'),
(6, '16', 'ARAPONGAS', '43 3303-5500', 'CTA0530719 (OI)', 'APS/IP/00325 (100MB)', 'CTA0798186 (OI 50MB)', '15.375.991/0017-21', 'ARAPONGAS', 'PR'),
(7, '17', 'APUCARANA', '43 3202-5800', '4332025800 (EMBRATEL)', 'APU/IP/00434 (100MB)', 'CTA0798159 (OI 50MB)', '15.375.991/0018-02', 'APUCARANA', 'PR'),
(8, '00', 'MATRIZ', '65 2128-5050', '6521285050 (EMBRATEL) / CPE04782 (OI)', 'CBA0497885 (VPN OI)', 'CBA0466870 (OI) / CBA0474524 (OI)', '15.375.991/0001-64', 'VARZEA GRANDE', 'MT'),
(9, '01', 'CARMINDO DE CAMPOS', '65 3617-5000', 'CBA0412469 (OI)', 'CBA/IP/04470', '0455427 (OI)', '15.375.991/0003-26', 'CUIABÁ', 'MT'),
(10, '02', 'VÁRZEA GRANDE', '65 3688-5000', 'CBA0413666 (OI)', 'VAZ/IP/00112', 'CBA0471803 (OI)', '15.375.991/0001-64', 'VARZEA GRANDE', 'MT'),
(11, '03', 'CÁCERES', '65 3211-6000', 'CBA0422648 (OI)', 'CCS/IP/00405', 'CBA0497484 (OI)', '15.375.991/0005-98', 'CÁCERES', 'MT'),
(12, '04', 'SINOP', '66 3511-5000', 'CBA0415640 (OI)', 'SNO/IP/01050', 'CBA0455426 (OI)', '15.375.991/0004-07', 'SINOP', 'MT'),
(13, '06', 'RONDONÓPOLIS', '66 3411-8700', 'CBA0419720 (OI)', 'ROI/IP/01103', 'CBA0498033 (OI )', '15.375.991/0008-30', 'RONDONÓPOLIS', 'MT'),
(14, '09', 'SORRISO', '66 3545-8900', 'CBA0449066 (OI)', 'SSZ/IP/00389', 'CBA0498485 (OI)', '15.375.991/0011-36', 'SORRISO', 'MT'),
(15, '10', 'HOME CENTER', '65 3615-5000', 'CBA0425904 (OI)', 'CBA/IP/04468', 'CBA0497491 (OI )', '15.375.991/0006-79', 'CUIABÁ', 'MT'),
(16, '12', 'FERNANDO CORREA', '65 3611-4500', 'CBA0497498 (OI)', 'CBA/IP/04471', 'CBA0431965 (OI )', '15.375.991/0013-06', 'CUIABÁ', 'MT'),
(17, '13', 'CPA', '65 2128-5506', '6521285506 (EMBRATEL)', 'CBA/IP/04472', '049 7504 (OI )', '15.375.991/0014-89', 'CUIABÁ', 'MT'),
(18, '14', 'CD-MT ', '65 3928-5550', 'CBA0438580 (OI)', '', 'CBA0466921 (OI)', '15.375.991/0015-60', 'CUIABÁ', 'MT'),
(19, '15', 'PONTES E LACERDA', '65 3266-9400', 'CBA0436219 (OI)', 'PCK/IP/00191', 'CBA0498031 (OI )', '15.375.991/0016-40', 'PONTES E LACERDA', 'MT'),
(20, '18', 'PRIMAVERA DO LESTE', '66 3500-5000', 'CBA0452049 (OI)', 'PVT/IP/00145', 'LP 673020140272490 (VIVO)', '15.375.991/0019-93', 'PRIMAVERA DO LESTE', 'MT'),
(21, '19', 'BARRA DO GARÇAS', '66 3402-1700', 'CBA0448496 (OI)', 'BAG/IP/00213', 'CBA0466869 (OI )', '15.375.991/0020-27', 'BARRA DO GARÇAS', 'MT'),
(22, '20', 'ARENA PANTANAL', '65 3615-5523', '(EMBRATEL)?', 'CBA/IP/04473', '049-7500 (OI )', '15.375.991/0021-08', 'CUIABÁ', 'MT'),
(23, '22', 'OUTLET', '65 3611-4537', '(EMBRATEL)?', '', '', '15.375.991/0023-70', 'CUIABÁ', 'MT'),
(24, '23', 'LUCAS DO RIO VERDE', '65 3548-2000', 'CBA0494838 (OI)', 'LRV/IP/00517', 'CBA0494800 (OI )', '15.375.991/0024-50', 'LUCAS DO RIO VERDE', 'MT'),
(25, '24', 'TANGARÁ DA SERRA', '65 3339-7000', 'CBA0495366 (OI)', 'TGS/IP/00188', 'CBA0496506 (OI)', '15.375.991/0025-31', 'TANGARÁ DA SERRA', 'MT'),
(26, '25', 'NOVA MUTUM', '65 3308-6200', 'CBA0498437 (OI)', 'NMM/IP/00291', 'CBA0498451 (OI )', '15.375.991/0026-12', 'NOVA MUTUM', 'MT'),
(27, '35', 'CAMPO NOVO DO PARECIS', '65 3382-6500', 'CBA0474176 (OI)', 'CZN/IP/00116', 'CBA0474172 (OI)', '15.375.991/0036-94', 'CAMPO NOVO DO PARECIS', 'MT'),
(28, '36', 'ALTA FLORESTA', '66 4004-6700	', '(EMBRATEL-SIP)', '', '672520178283393 (VIVO)', '15.375.991/0037-75', 'ALTA FLORESTA', 'MT'),
(29, '37', 'CAMPO VERDE', '66 3419-9250', 'CBA0474039 (OI)', 'CZV/IP/00134', 'CBA0474040 (OI)', '15.375.991/0038-56', 'CAMPO VERDE', 'MT'),
(30, '39', 'SINOP AEROPORTO', '66 2132-9090', '(EMBRATEL)', 'SNO/IP/01083', 'CBA0474786 (OI)', '15.375.991/0040-70', 'SINOP ', 'MT'),
(31, '40', 'PRIMAVERA BELVEDERE', '66 3016-3970', '(VIVO)', 'PVT/IP/00147', '673020194682397 (VIVO)', '15.375.991/0041-51', 'PRIMAVERA DO LESTE', 'MT'),
(32, 'A1', 'TODIMO TRANSPORTES', '65 3928-5569', '(OI)', '', '', '26.792.523/0001-01', 'CUIABÁ', 'MT'),
(33, '00', 'CORPORATIVO', '65 2128-5000', '(EMBRATEL)', '', '', '15.375.991/0001-64', 'VARZEA GRANDE', 'MT'),
(34, '001', 'MUNDO DA OBRA (ATACAREJO)', '65 2193-2990	', '(EMBRATEL)', 'CBA/IP/05134', '670000195185091 (VIVO)', '57.590.454/0001-87', 'CUIABÁ', 'MT'),
(35, 'S/N', 'HORIZONTE PARTICIPAÇÕES', '65 3688-4900', '(OI)', '', '', '', 'VARZEA GRANDE', 'MT'),
(36, 'S/N', 'CUIABÁ LAR SHOPPING', '65 3901-1200', '(OI)', '', '', '', 'CUIABÁ', 'MT'),
(37, 'A3', 'CD-MS CAMPO GRANDE', '67 3357-1748', '', '', 'CBA0496507 (OI)', '15.375.991/0007-50', 'CAMPO GRANDE', 'MS'),
(38, '26', 'HOME CENTER - CAMPO GRANDE', '67 3357-1700', 'CPE0469389 (OI)', 'CPE/IP/04432 ', 'CPE0468874 (OI )', '15.375.991/0027-01', 'CAMPO GRANDE', 'MS'),
(39, '29', 'BANDEIRANTES', '67 3378-1600', 'CPE0470533 (OI)', 'CPE/IP/04431', 'CPE0470520 (OI )', '15.375.991/0030-07', 'CAMPO GRANDE', 'MS'),
(40, '30', 'JULIO DE CASTILHO', '67 3357-5000', 'CPE0471411 (OI)', 'CPE/IP/04434', 'CPE0471412 (OI )', '15.375.991/0031-80', 'CAMPO GRANDE', 'MS'),
(41, '31', 'DOURADOS', '67 3420-7900', 'CPE0472472 (OI)', '', 'CPE0472458 (OI )', '15.375.991/0032-60', 'DOURADOS', 'MS'),
(42, '32', 'TRÊS LAGOAS', '67 3919-2400', 'CPE0472453 (OI)', 'TLS/IP/01527', 'CPE0472451 (OI) / CPE0473397 (OI)', '15.375.991/0033-41', 'TRÊS LAGOAS', 'MS'),
(43, '33', 'CD LOJA TRÊS LAGOAS', '67 3919-2400', '(OI - MESMO DA LOJA)', '', '', '', 'TRÊS LAGOAS', 'MS'),
(44, '34', 'CALÓGERAS', '67 3311-7100', 'CPE0474588 (OI)', 'CPE/IP/04433 ', 'CPE0474589 (OI )', '15.375.991/0035-03', 'CAMPO GRANDE', 'MS'),
(45, '38', 'MARACAJU', '67 4007-6700/6704004-6766', '(SIP SINOP)', '', '', '15.375.991/0039-37', 'MARACAJU', 'MS'),
(46, 'A3', 'TRANSPORTE CAMPO GRANDE	', '67 3357-1748', 'MESMO DE CD-MS', 'MESMO DE CD-MS', 'MESMO DE CD-MS', '', 'CAMPO GRANDE	', 'MS'),
(47, 'A2', 'TODIMO TRANSPORTES PR', '43 3376-5506', 'MESMO CD-PR', 'MESMO CD-PR', 'MESMO CD-PR', '26.792.523/0002-92', 'LONDRINA', 'PR');

-- --------------------------------------------------------

--
-- Estrutura para tabela `fornecedores`
--

CREATE TABLE `fornecedores` (
  `id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `endereco` varchar(150) NOT NULL,
  `telefone` varchar(300) NOT NULL,
  `contato` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cadastro de Fornecedores';

--
-- Despejando dados para a tabela `fornecedores`
--

INSERT INTO `fornecedores` (`id`, `nome`, `endereco`, `telefone`, `contato`) VALUES
(1, '3G Automação - Manutenção de Cancelas de Estacionamento', 'R. Alameda Miguel Blazi, 83 3º piso ', '(43) 3323-8548 / (43) 99109-0040', 'Rosano '),
(2, 'Alarm Force - Alarme e Monitoramento (Atual)', 'R. Rio Grande do Sul, 317', '(43) 3158-1035 | (43) 99129-0713 (Ronaldo) | (43) 99618-3846 (Andre)', 'Técnico Andre'),
(3, 'AlfaCopy - Cartucho de Tinta & Toners de Impressoras', 'R. Eleonor Roosevelt, 322', '(43) 3026-1644', 'Ana'),
(4, 'Alternativa - Recarga de Toners, Locação e Manutenção de impressoras', 'R. Catarina de Bora, 329 - Vila Siam', '(43) 3326-6262', 'Jessica, Cintia, Rony e Leonardo (diretor)'),
(5, 'Automaq - Automação Comercial', ' R. Quintino Bocaiuva, 833', '(43) 3324-5385', 'Mayara, Camila e Everaldo'),
(6, 'Automatech - Soluções 360º', 'R. Dr. João Inácio, 1110 - Porto Alegre-RS', '(51) 3017-8300 / Fax: (51) 3017-8321', ' Matheus Torres (matheus@automatech.com.br), Leonardo'),
(7, 'Banca Suprimentos - Toners e Suprimentos de informática', 'R. Brasil, 1700', '(43) 3026-3006', 'Diogo, Tiago'),
(8, 'Banco Safra', '', '(11) 3175-8190 / SAC 0800-0157-575 / TI Safra (11) 3175-9782', 'Suporte'),
(9, 'Bematech - Impressoras ECF, Pinped, Automação', '', '0800-6442-362', ''),
(10, 'Casa do Toner', 'R. Quintino Bocaiuva, 576', '(43) 3321-3362', ''),
(11, 'Catuaí - Ar Condicionados ', 'R. Paranaguá, 1306', '(43) 3357-1001 / (43) 99151-0000', ''),
(12, 'Centermaq - Calculadora de bobina e móveis de escritório', 'R. Guaporé, 423', '(43) 3336-1234', ''),
(13, 'Cielo - Maquinetas', '', '4002-9111 / Suporte 0800-5700-111 / Rel. Cliente 0800-570-8472', ''),
(14, 'Copel - Fornecimento de Energia Elétrica', 'R. Chile, 10 - Vila Brasil, Londrina - PR', '(43) 3375-2000 / SAC 0800-510-0116', ''),
(15, 'DBL Baterias - Baterias automotivas/Nobreak ', 'Av. Arthur Tomas, 848 ', '(43) 3327-8080 / (43) 99991-5230', 'João'),
(16, 'Dicomag - Calculadora de bobina e móveis de escritório ', 'Av. Maringá, 2067 B - Vitoria, Londrina - PR', '(43) 3356-5656 / Ricardo Borges (43) 98406-5656', ''),
(17, 'Digifort - Software Câmeras IP', 'São Paulo-SP', '(11) 4226-2386', ''),
(18, 'Digitemp - CFTV, infra', ' Av. São João, 595', '(43) 3323-8631 / Edi (43) 99991-2386 / Anibal (43) 99943-8631', 'Soraira, Edi César, Anibal e Eric'),
(19, 'Dimep Cuiabá-MT - Relógio Ponto', '', '(65) 3634-1950 / (65) 3634-4595', ''),
(20, 'Automatec SAAC - Dimep Londrina-PR ', 'Av. Leste Oeste, 2770 Sl. 6, 7, 8', '(43) 3356-3133 (Téc. Júnior / Cleber / Fabio Jr.) / Julio Vendas (43) 99665-2285', 'Sr. Airton / Rogério'),
(21, 'Beta Informática', 'R. Humaitá, 875 - Kennedy', '(43) 3024-5004', ''),
(22, 'Dn Conetividade - Infraestrutura', 'Rua Jose Oiticica, 176', '(43) 3878-7676 / 99617-8885 ', 'Fabio'),
(23, 'ECD Multicabos - Infraestrutura telecom', 'Av. Celso Garcia Cid, 1265 ', '(43) 3305-7700 / 7729 / 7736 / 7726 (Gabriel)', 'Evaldo e Sérgio'),
(24, 'Eletrocabines - Instalação e Manutenção Elétrica ', 'R. Walter Pereira, 875', '(43) 3348-4105 / (43) 98812-6773 (Cirlando)', 'Cirlando e Andreza'),
(25, 'Eletrônica Videocolor - Assistencia Técnica Autorizada Samsung (Monitores, TVs)', 'Av. JK, 3768', '(43) 3324-6716 ', ''),
(26, 'Eletrotrafo - Produtos Elétricos', 'Av. Tiradentes, 1340 ', '(43) 3520-5000', 'Braga'),
(27, 'E-letro (Antigo E-Lixo) - Reciclagem de Eletrônicos', 'R. Ermelindo Leão, 385B', '(43) 3339-0475', ''),
(28, 'Embratel / Claro - Operadora de Telefonia e Link de dados', '', 'Chamado 0800-721-2021 / Osmeire (65) 2121-7153, (65)99287-3875 / link - Paulo Silva (31) 2121-3856', 'Ger. Contas Osmeire'),
(29, 'Equinorte - Nobreak, Elétrica', 'R. Paranavaí, 95', '(43) 3348-0343 / (43) 3357-1615', 'Contato: Judith'),
(30, 'Eucatur - Frete / Logística', 'Av. 10 de Dez, 1830 bx 29, 31', '(43) 3322-2321 / 3325-8816', 'Dener | e-mail: encom.londrina@eucatur.com.br (Carta de correção)'),
(31, 'Garcia Express - Frete, encomendas ', 'Av. Celso Garcia Cid, 1100 (Entrada na rua ao lado)', '(43) 3373-2390', ''),
(32, 'Gertec - Automação, PinPad', '', '(11) 2173-6500', ''),
(33, 'Gol Log - Frete/ logística', 'R. Gastão Madeira - Dom Pedro (Fechado entrada Av. Santos Dumont, 1610)', '(43) 3356-0200 / (43) 3336-0889', ''),
(34, 'Hayamax - Produtos eletrônicos', 'Rua Ronat Walter Sodre, 500 - Pq. Ind. Castelo Branco - Ibiporã-PR', '(43) 3377-6600 (Guilherme Barbosa) / Financeiro 6849 / Garantia 6724', ''),
(35, 'HB Cartuchos e Impressoras ', 'Av. Arthur Tomas, 711', '(43) 3029-5884', 'Allana e Mateus'),
(36, 'HelpFax - Impressoras e toners (Autorizada Epson, Xerox, Canon e NEC)', 'Rua Quintino Bocaiuva, 584 - Centro', '(43) 3321-2927', ''),
(37, 'Hotel Thomasi Londrina-PR', ' Av. Tiradentes, 1155', '(43) 3315-0400', ''),
(38, 'Kalunga Boulivard - Materiais p/ escritório e informática', 'Shopping Boulivard | Londrina-PR', '(43) 3329-3888', ''),
(39, 'Lepok - Materiais de Escritório', 'São Paulo-SP', '(11) 2672-7400', ''),
(40, 'Leoncio - Telefonia terceirizada Todimo', 'Cuiabá-MT', '(65) 99981-6168 / (65) 98477-9817', ''),
(41, 'R.E. Telecomunicações - Leucontron ', 'R. Rio Grande do Sul, 999 Sl 13 - Jd. Apucarana - Apucarana-PR', '(43) 3422-7979', ''),
(42, 'Telles Comunicações Ltda. ME - Leucontron ', 'R. Peru, 197 - Jd. Diamantina - Apucarana-PR', '(43) 3033-7777 / 3426-0000 / 99918-9046 / 99918-9045', 'Mirian e Telles'),
(43, 'Link Cancelas - Estacionamento', 'Cuiabá-MT / São Paulo-SP', 'Cristiano (65) 9265-8757 (011) 9321-22140/9939-12017 ou Cleidson', ''),
(44, 'Line Fort - Segurança e Vigilância', 'R. Ibiporã, 699 - Jd. Stº Antonio', '(43) 3025-2101', 'Valdir e Cida'),
(45, 'LondriService - Ar Condicionado', '', '(43) 3336-8000 / (43) 99965-3671 (Marcos)', 'técnico Marcos'),
(46, 'Maranata Telecom ', 'R. Cambará, 371', '(43) 3374-6700 / (43) 99166-5060 (Sandro) / (43) 99162-1879 (Marcelo)', 'Sandro'),
(47, 'Nobreak Londrina', 'R. Café com Leite, 162', '(43) 3357-0207 / (43) 3324-4044 / (43) 98402-7050', 'Reginaldo'),
(48, 'Notebook Service - Manutenção de notebook', 'Av. Souza Naves, 410 Lj 08', '(43) 3329-2202', 'Washington Luis'),
(49, 'Oi - Operadora de Telefonia', '', '0800-0310-800 / (43) 98447-2875 (Bruno RM)', ''),
(50, 'Prosiga - Alarme e Segurança', 'R. Guilherme da Mota Corrêa, 3399 - Jardim Shangri-Lá A, Londrina-PR', '(43) 3028-2121 / (43) 99164-7614, (43) 97811-3895 (Diogo - desligado)', 'Fátima / Rogério - Técnica: Denilson / Fernando'),
(51, 'Receita Estadual - Arapongas', 'R. Flamingo, 827 - Arapongas-PR', '(43) 3252-1734', ''),
(52, 'Receita Estadual - Londrina', 'R. Pará, 473 - Londrina-PR', '(43) 3372-2100', ''),
(53, 'Relojoaria Relotex - Relógio Ponto', 'R. Sergipe, 288', '(43) 3323-1360', 'Ueda Tetsuo e Carlos'),
(54, 'Renogás - Ar Condicionado', 'R. Arapongas, 775 - Arapongas-PR', '(43) 3152-02166', ''),
(55, 'SelfColor Suvinil - Basf', '', '0800-011-7558 / (43) 99109-0099 (Idionor)', ''),
(56, 'Sercomtel - Operadora de Telefonia', 'R. João Cândido, 555', '3375-1381 / 99996-9881 (Gislene) | 3375-1901 (Renanzinho) | 99992-7440 / 98418-7801 (Antenor DirectInfo) | 103 43 (Chamados) / 0800-400-1901 (Clientes Corp.)', 'Gislene, Renan.'),
(57, 'Sonkey - Som, Eletrônicos e Componentes', 'R. Souza Naves, 9', '(43) 3377-6800', 'Gabriel'),
(58, 'Só Tech - Componentes Eletrônicos', 'R. Santa Catarina, 142 - Centro, Londrina - PR', '(43) 3323-2960', ''),
(59, 'Tecnocenter Telecom. e Informática LTDA - Autorizada Leucotron', 'Rua Brasil, 1014 - Sala 501', '(43) 3377-5757', ''),
(60, 'EMAXX - Thin Client WinBox', 'São Paulo-SP', '(11) 3562-7005 ', 'Dante Casale (dante.casale@emaxx.com.br), Gabriel Cloretti (vendas2@emaxx.com.br) e Betânia | e-mail comercial: comercial@emaxx.com.br'),
(61, 'Tecpoint - Leitores de cheque SuperBank', 'São Paulo-SP', '(11) 4199-1799', ''),
(62, 'Teruo Informatica - Materiais de informática', 'Cuiabá-MT', '(65) 3623-1499', 'Emilia'),
(63, 'Via Nobreak - Manutenção Nobreak', 'R. Bolonha, 160', '(43) 3343-2018', ''),
(64, 'Contpel - Papelaria', 'R. Belo Horizonte, 370 - Centro, Londrina - PR', '(43) 3337-5095', ''),
(65, 'Computec Informática', 'Av. Juscelino Kubitscheck, 2086 - Centro, Londrina - PR', '(43) 3372-1211', ''),
(66, 'Altatech Soluções em Tecnologia Ltda.', 'R. Sen. Souza Naves, 282 - Centro', '(43) 2105-1002 / 1004 (Emanuel)', 'Emanuel Rodrigues'),
(67, 'Multicabos - Infraestrutura telecom', 'R. Pirapó, 267 - Vila Zanetti, Londrina - PR', ' (43) 3305-7777 | Whatsapp Claudia (43) 98821-8474', 'Claudia'),
(68, 'Solução Impressoras (Jato de Tinta)', 'Av. Arcebispo Dom Geraldo Fernandes, 2770 - Loja 19', '(43) 3025-2733 | (43) 99631-3145', 'Rafael (suprimentoslondrina@gmail.com)'),
(69, 'Kalunga Catuaí - Materiais p/ escritório e informática', 'Shopping Catuaí | Londrina-PR', '(43) 3025-6157', ''),
(72, 'Londritech Informática', 'Av. Juscelino Kubitscheck, 320 - Jardim Santo Antonio, Londrina - PR', '(43) 3328-4040', '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `login` varchar(150) NOT NULL,
  `senha` varchar(50) NOT NULL COMMENT 'password',
  `nome` varchar(150) NOT NULL,
  `privilegios` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `login`, `senha`, `nome`, `privilegios`) VALUES
(1, 'luis.kurihara', 'eef805b367166ad0364a6c89c9292551', 'Luis Kurihara (Md5)', 'admin'),
(2, 'suporte', '5cb8ff4a442e6d8eee7ce31e42819079', 'Suporte Infra', 'basic'),
(3, 'central', '21e02a324570393ebdee8af53c6e04f9', 'Central ', 'basic'),
(4, 'infra', '2806a200e425556411970a7bc903bf02', 'infraestrutura', 'basic');

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendedores`
--

CREATE TABLE `vendedores` (
  `id` int(11) NOT NULL COMMENT 'código id',
  `nome` varchar(150) NOT NULL COMMENT 'Nome',
  `local` varchar(200) NOT NULL COMMENT 'Local Base',
  `ramal` int(4) NOT NULL COMMENT 'Ramal',
  `senha` varchar(6) NOT NULL COMMENT 'Senha telefônica'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `vendedores`
--

INSERT INTO `vendedores` (`id`, `nome`, `local`, `ramal`, `senha`) VALUES
(1, 'Suelen', 'BalcÃ£o Corredor Entrada', 5516, '4556'),
(2, 'Thiago', 'Lado mesa Henrique', 5517, ''),
(3, 'VAGO', 'Selfcolor3', 5519, '1321'),
(4, 'Manu', 'Selfcolor4', 5522, '4513'),
(5, 'Aghata', 'Selfcolor5', 5523, '6512'),
(6, 'Novak (VAGO)', 'Cadastro2', 5525, ''),
(7, 'Karen', 'Cadastro1', 5526, ''),
(8, 'Rafaela', 'Showroom Ceusa', 5529, ''),
(9, 'Mariana', 'Selfcolor6', 5530, ''),
(10, 'Denise', 'Selfcolor8', 5531, '9236'),
(11, 'Victor (VAGO)', 'Selfcolor2', 5532, ''),
(12, '(VAGO)', 'Showroom Incepa', 5533, ''),
(13, 'Pedro', 'Showroom Portobello', 5534, ''),
(14, 'Diorgenes', 'Selfcolor7', 5535, '3220'),
(15, 'VAGO', 'Showroom Eliane', 5538, '1856'),
(16, 'Marcela', 'Cadastro3', 5542, ''),
(17, 'Livia', 'Showroom Biancogres', 5545, '2523'),
(18, 'Juarez', 'Mesa Arquiteta', 5560, '8714'),
(19, 'Maicon', 'Mesa lado Arquiteta', 5561, ''),
(20, 'Sidval', 'BalcÃ£o lado etiquetas', 5521, '3422');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `filiais`
--
ALTER TABLE `filiais`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `fornecedores`
--
ALTER TABLE `fornecedores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `usuarios` ADD FULLTEXT KEY `senha` (`senha`);
ALTER TABLE `usuarios` ADD FULLTEXT KEY `MD5` (`senha`);

--
-- Índices de tabela `vendedores`
--
ALTER TABLE `vendedores`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `filiais`
--
ALTER TABLE `filiais`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de tabela `fornecedores`
--
ALTER TABLE `fornecedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `vendedores`
--
ALTER TABLE `vendedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'código id', AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
