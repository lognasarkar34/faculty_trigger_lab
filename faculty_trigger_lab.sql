-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 19, 2026 at 07:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `faculty_trigger_lab`
--

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmpID` int(11) NOT NULL,
  `EmpName` varchar(100) NOT NULL,
  `BasicSalary` decimal(10,2) NOT NULL,
  `StartDate` date NOT NULL,
  `NoOfPub` int(11) NOT NULL CHECK (`NoOfPub` >= 0),
  `IncrementRate` decimal(5,2) DEFAULT 0.00,
  `UpdatedSalary` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmpID`, `EmpName`, `BasicSalary`, `StartDate`, `NoOfPub`, `IncrementRate`, `UpdatedSalary`) VALUES
(1, 'Rahim', 30000.00, '2022-01-10', 6, 20.00, 36000.00),
(2, 'Karim', 28000.00, '2023-05-15', 3, 0.00, 28000.00),
(3, 'Anika', 35000.00, '2021-03-20', 1, 5.00, 36750.00),
(4, 'Sadia', 40000.00, '2024-02-01', 0, 0.00, 40000.00),
(5, 'Nabil', 32000.00, '2020-07-11', 3, 10.00, 35200.00),
(6, 'Farhan', 45000.00, '2022-08-18', 6, 0.00, 45000.00),
(7, 'Tania', 37000.00, '2025-01-01', 3, 0.00, 37000.00),
(8, 'Rafi', 29000.00, '2023-01-01', 0, 0.00, 29000.00);

--
-- Triggers `employee`
--
DELIMITER $$
CREATE TRIGGER `trg_salary_log` AFTER UPDATE ON `employee` FOR EACH ROW BEGIN
    IF OLD.UpdatedSalary <> NEW.UpdatedSalary THEN
        INSERT INTO SALARY_LOG (EmpID, OldSalary, NewSalary, Note)
        VALUES (
            NEW.EmpID,
            OLD.UpdatedSalary,
            NEW.UpdatedSalary,
            'Salary updated based on policy'
        );
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_salary_update` BEFORE UPDATE ON `employee` FOR EACH ROW BEGIN
    DECLARE years INT;

    SET years = TIMESTAMPDIFF(YEAR, NEW.StartDate, CURDATE());

    IF years > 1 AND NEW.NoOfPub > 4 THEN
        SET NEW.IncrementRate = 20;
    ELSEIF years > 1 AND NEW.NoOfPub IN (2,3) THEN
        SET NEW.IncrementRate = 10;
    ELSEIF years > 1 AND NEW.NoOfPub = 1 THEN
        SET NEW.IncrementRate = 5;
    ELSE
        SET NEW.IncrementRate = 0;
    END IF;

    SET NEW.UpdatedSalary = NEW.BasicSalary + 
        (NEW.BasicSalary * NEW.IncrementRate / 100);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `salary_log`
--

CREATE TABLE `salary_log` (
  `LogID` int(11) NOT NULL,
  `EmpID` int(11) DEFAULT NULL,
  `OldSalary` decimal(10,2) DEFAULT NULL,
  `NewSalary` decimal(10,2) DEFAULT NULL,
  `ChangedAt` datetime DEFAULT current_timestamp(),
  `Note` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `salary_log`
--

INSERT INTO `salary_log` (`LogID`, `EmpID`, `OldSalary`, `NewSalary`, `ChangedAt`, `Note`) VALUES
(1, 1, 30000.00, 36000.00, '2026-04-19 23:04:11', 'Salary updated based on policy'),
(2, 5, 32000.00, 35200.00, '2026-04-19 23:04:11', 'Salary updated based on policy'),
(3, 3, 35000.00, 36750.00, '2026-04-19 23:04:11', 'Salary updated based on policy');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmpID`);

--
-- Indexes for table `salary_log`
--
ALTER TABLE `salary_log`
  ADD PRIMARY KEY (`LogID`),
  ADD KEY `EmpID` (`EmpID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `salary_log`
--
ALTER TABLE `salary_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `salary_log`
--
ALTER TABLE `salary_log`
  ADD CONSTRAINT `salary_log_ibfk_1` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
