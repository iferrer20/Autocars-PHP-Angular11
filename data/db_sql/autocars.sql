-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 03, 2021 at 02:05 PM
-- Server version: 8.0.22
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `autocars`
--

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `id` int NOT NULL,
  `brand` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`id`, `brand`) VALUES
(1, 'Audi'),
(2, 'BMW'),
(3, 'Buick'),
(4, 'Cadillac'),
(5, 'Chevrolet'),
(6, 'Chrysler'),
(7, 'Dodge'),
(8, 'Ferrari'),
(9, 'Ford'),
(10, 'GM'),
(11, 'GEM'),
(12, 'GMC'),
(13, 'Honda'),
(14, 'Hummer'),
(15, 'Hyundai'),
(16, 'Infiniti'),
(17, 'Isuzu'),
(18, 'Jaguar'),
(19, 'Jeep'),
(20, 'Kia'),
(21, 'Lamborghini'),
(22, 'Land Rover'),
(23, 'Lexus'),
(24, 'Lincoln'),
(25, 'Lotus'),
(26, 'Mazda'),
(27, 'Mercedes-Benz'),
(28, 'Mercury'),
(29, 'Mitsubishi'),
(30, 'Nissan'),
(31, 'Oldsmobile'),
(32, 'Peugeot'),
(33, 'Pontiac'),
(34, 'Porsche'),
(35, 'Regal'),
(36, 'Saab'),
(37, 'Saturn'),
(38, 'Subaru'),
(39, 'Suzuki'),
(40, 'Toyota'),
(41, 'Volkswagen'),
(42, 'Volvo');

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE `cars` (
  `id` int NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `km` int NOT NULL,
  `price` int NOT NULL,
  `brand` int NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `views` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cars`
--

INSERT INTO `cars` (`id`, `description`, `km`, `price`, `brand`, `name`, `at`, `views`) VALUES
(3, 'hola q tal', 20000, 5000, 1, 'Audi Q2', '2021-03-01 05:14:09', 0),
(4, 'hola q tal', 20000, 6000, 1, 'yolanda', '2021-03-01 00:14:16', 10),
(5, 'hola q tal', 20000, 15000, 1, 'Audi Q2', '2021-03-01 05:14:27', 27),
(6, 'hola q tal 3', 200, 9000, 1, 'Audi', '2021-03-01 05:14:40', 0),
(7, 'hola q tal 3', 200, 5000, 1, 'Audi', '2021-03-01 05:17:35', 1),
(8, 'hola q tal 3', 200, 30000, 1, 'Audi', '2021-03-01 05:17:38', 0),
(9, 'hola q tal 3', 200, 5000, 1, 'Audi', '2021-03-01 05:17:38', 3),
(10, 'hola q tal 3', 200, 50000, 1, 'Audi', '2021-03-01 05:17:38', 1),
(24, 'asdf', 200, 2000, 1, 'Audi', '2021-03-03 12:08:54', 0),
(25, 'asdf', 200, 2000, 1, 'Audi', '2021-03-03 12:09:03', 0),
(26, 'asdf', 200, 2000, 1, 'Audi', '2021-03-03 12:09:05', 0),
(27, 'asdf', 200, 2000, 1, 'Audi', '2021-03-03 12:09:08', 1),
(28, 'asdf', 200, 2000, 1, 'Audi', '2021-03-03 12:09:10', 0),
(29, 'Coche furgoneta', 200, 2000, 1, 'Coche furgoneta', '2021-03-03 12:09:55', 0),
(30, 'Coche monovolumen', 200, 2000, 1, 'Coche Monovolumen', '2021-03-03 12:10:21', 0),
(31, 'Coche deportivo', 200, 40000, 1, 'Coche deportivo', '2021-03-03 12:10:54', 2),
(32, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:11:10', 0),
(33, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:38', 0),
(34, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:38', 0),
(35, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:38', 0),
(36, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:39', 0),
(37, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:39', 0),
(38, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:40', 0),
(39, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:40', 0),
(40, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:41', 0),
(41, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:41', 0),
(42, 'Coche deportivo', 200, 9000, 1, 'Coche todoterreno', '2021-03-03 12:43:42', 0);

-- --------------------------------------------------------

--
-- Table structure for table `car_category`
--

CREATE TABLE `car_category` (
  `car_id` int NOT NULL,
  `category_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `car_category`
--

INSERT INTO `car_category` (`car_id`, `category_id`) VALUES
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(24, 2),
(25, 4),
(26, 3),
(27, 2),
(28, 1),
(29, 4),
(30, 3),
(31, 2),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(42, 1);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int NOT NULL,
  `category` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `category`) VALUES
(1, 'offroad'),
(2, 'sporty'),
(3, 'minivan'),
(4, 'van');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` bigint NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `firstName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastName` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birthday` date NOT NULL,
  `gender` enum('MALE','FEMALE','OTHER') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brand` (`brand`);

--
-- Indexes for table `car_category`
--
ALTER TABLE `car_category`
  ADD KEY `car_category_ibfk_1` (`car_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `cars`
--
ALTER TABLE `cars`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cars`
--
ALTER TABLE `cars`
  ADD CONSTRAINT `cars_ibfk_1` FOREIGN KEY (`brand`) REFERENCES `brands` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `car_category`
--
ALTER TABLE `car_category`
  ADD CONSTRAINT `car_category_ibfk_1` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `car_category_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
