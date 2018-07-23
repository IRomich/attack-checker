-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 23, 2018 at 06:43 PM
-- Server version: 5.7.22-0ubuntu0.16.04.1
-- PHP Version: 7.0.30-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `logs_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cpu_analysis_procedure` ()  begin
   
    DECLARE i INT DEFAULT 2;
    DECLARE count_domain INT DEFAULT 0;
    
    TRUNCATE TABLE cpu_analysis;
        
    SET count_domain = (SELECT COUNT(*) FROM apache_logs_domain);
    
	WHILE i <= count_domain DO
        SET SQL_BIG_SELECTS=1;
		INSERT INTO cpu_analysis(log_time_cpu, log_time_apache, ip, domain, page, last_request, extension, cpu)
        
		SELECT B.log_time, C.log_time, C.ip, C.domain, C.page, B.last_request, B.extension, B.cpu
            FROM

                (SELECT cpu_logs.log_time, cpu_logs.last_request, cpu_logs.extension, cpu_logs.cpu
                    FROM 
                        (SELECT MIN(log_time) AS minimum, MAX(log_time) AS maximum, domain FROM `apache_logs` WHERE domain = i) AS A
                    INNER JOIN 
                        cpu_logs 
                        ON cpu_logs.domain = A.domain AND cpu_logs.log_time BETWEEN A.minimum AND A.maximum 
                        GROUP BY cpu_logs.log_time) AS B

            INNER JOIN

                (SELECT log_time, ip, domain, page FROM apache_logs WHERE domain = i) AS C
                ON (C.log_time + 0 BETWEEN B.log_time - 300 AND B.log_time + 60);
                
         SET i = i + 1;
	END WHILE;
    
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `apache_analysis`
--

CREATE TABLE `apache_analysis` (
  `id` int(10) UNSIGNED NOT NULL,
  `ip` varchar(100) CHARACTER SET utf8 NOT NULL,
  `count_all` mediumint(10) UNSIGNED NOT NULL,
  `count_black` mediumint(10) UNSIGNED NOT NULL,
  `count_black_time` mediumint(10) UNSIGNED NOT NULL,
  `count_code` mediumint(10) UNSIGNED NOT NULL,
  `count_code_sequence` int(10) NOT NULL,
  `user_agent` mediumint(10) UNSIGNED NOT NULL,
  `count_time_cpu` int(10) NOT NULL,
  `max_cpu` decimal(10,2) NOT NULL,
  `ml` tinyint(1) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apache_analysis_domain`
--

CREATE TABLE `apache_analysis_domain` (
  `id` int(10) NOT NULL,
  `count_request` int(10) NOT NULL,
  `median_request` int(10) NOT NULL,
  `avg_request` int(10) NOT NULL,
  `count_ip` int(10) NOT NULL,
  `median_ip` int(10) NOT NULL,
  `avg_ip` int(10) NOT NULL,
  `count_code` int(10) NOT NULL,
  `percent_code` int(10) NOT NULL,
  `domain` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apache_analysis_ml`
--

CREATE TABLE `apache_analysis_ml` (
  `id` int(10) NOT NULL,
  `ip` varchar(100) CHARACTER SET utf8 NOT NULL,
  `sequence_request` decimal(20,10) NOT NULL,
  `sequence_404` decimal(20,10) NOT NULL,
  `user_agent` tinyint(1) NOT NULL,
  `method_request` tinyint(1) NOT NULL,
  `t_avg` decimal(20,10) NOT NULL,
  `interval_t` int(10) NOT NULL,
  `count_request` int(10) NOT NULL,
  `count_0_9_1_1_sequence` decimal(20,10) NOT NULL,
  `count_0_9_1_1_request` int(10) NOT NULL,
  `cpu` tinyint(1) NOT NULL,
  `count_black` int(11) NOT NULL,
  `count_code_sequence` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apache_logs`
--

CREATE TABLE `apache_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `ip` varchar(100) CHARACTER SET utf8 NOT NULL,
  `log_time` int(10) NOT NULL,
  `method_request` int(10) UNSIGNED NOT NULL,
  `domain` int(10) UNSIGNED NOT NULL,
  `page` text CHARACTER SET utf8 NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `code` int(10) UNSIGNED NOT NULL,
  `size_bytes` mediumint(10) UNSIGNED NOT NULL,
  `url_referer` text CHARACTER SET utf8 NOT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apache_logs_code`
--

CREATE TABLE `apache_logs_code` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apache_logs_domain`
--

CREATE TABLE `apache_logs_domain` (
  `id` int(10) UNSIGNED NOT NULL,
  `domain` varchar(60) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apache_logs_method_request`
--

CREATE TABLE `apache_logs_method_request` (
  `id` int(10) UNSIGNED NOT NULL,
  `method_request` varchar(7) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apache_logs_version`
--

CREATE TABLE `apache_logs_version` (
  `id` int(10) UNSIGNED NOT NULL,
  `version` varchar(8) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `aut`
--

CREATE TABLE `aut` (
  `id` int(10) NOT NULL,
  `login_user` varchar(32) CHARACTER SET utf8 NOT NULL,
  `pwd` varchar(255) CHARACTER SET utf8 NOT NULL,
  `email` varchar(32) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `bad_user_agents`
--

CREATE TABLE `bad_user_agents` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cpu_analysis`
--

CREATE TABLE `cpu_analysis` (
  `id` int(10) NOT NULL,
  `log_time_cpu` int(10) NOT NULL,
  `log_time_apache` int(10) NOT NULL,
  `ip` varchar(100) CHARACTER SET utf8 NOT NULL,
  `domain` int(10) UNSIGNED NOT NULL,
  `page` text CHARACTER SET utf8 NOT NULL,
  `last_request` text CHARACTER SET utf8 NOT NULL,
  `extension` int(10) NOT NULL,
  `cpu` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cpu_analysis_uniq_log_time`
--

CREATE TABLE `cpu_analysis_uniq_log_time` (
  `id` int(10) NOT NULL,
  `log_time_cpu` int(10) NOT NULL,
  `count_uniq_ip` int(10) UNSIGNED NOT NULL,
  `count_uniq_domain` int(10) UNSIGNED NOT NULL,
  `count_uniq_page` int(10) UNSIGNED NOT NULL,
  `count_all_request` int(10) UNSIGNED NOT NULL,
  `cpu` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cpu_logs`
--

CREATE TABLE `cpu_logs` (
  `id` int(10) UNSIGNED NOT NULL,
  `log_time` int(10) NOT NULL,
  `cpu` decimal(10,2) NOT NULL,
  `command` int(10) UNSIGNED NOT NULL,
  `domain` int(10) UNSIGNED NOT NULL,
  `last_request` text CHARACTER SET utf8 NOT NULL,
  `extension` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cpu_logs_command`
--

CREATE TABLE `cpu_logs_command` (
  `id` int(10) UNSIGNED NOT NULL,
  `command` varchar(8) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `cpu_logs_file_extension`
--

CREATE TABLE `cpu_logs_file_extension` (
  `id` int(10) NOT NULL,
  `extension` varchar(255) CHARACTER SET utf8 NOT NULL,
  `level_of_danger` int(10) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `filters`
--

CREATE TABLE `filters` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `rule` text CHARACTER SET utf8 NOT NULL,
  `description` text CHARACTER SET utf8 NOT NULL,
  `tags` text CHARACTER SET utf8 NOT NULL,
  `impact` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ip_black_list`
--

CREATE TABLE `ip_black_list` (
  `id` int(11) NOT NULL,
  `ip` varchar(255) CHARACTER SET utf8 NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ip_white_list`
--

CREATE TABLE `ip_white_list` (
  `id` int(11) NOT NULL,
  `ip` varchar(255) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ram_key_value`
--

CREATE TABLE `ram_key_value` (
  `id` int(11) NOT NULL,
  `key_data` varchar(100) NOT NULL,
  `value_data` varchar(500) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `test_table`
--

CREATE TABLE `test_table` (
  `id` int(10) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `apache_analysis`
--
ALTER TABLE `apache_analysis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip` (`ip`),
  ADD KEY `user_agent` (`user_agent`),
  ADD KEY `count_black_time` (`count_black_time`),
  ADD KEY `count_code` (`count_code`);

--
-- Indexes for table `apache_analysis_domain`
--
ALTER TABLE `apache_analysis_domain`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apache_analysis_domain_fk_domain` (`domain`);

--
-- Indexes for table `apache_analysis_ml`
--
ALTER TABLE `apache_analysis_ml`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ip` (`ip`);

--
-- Indexes for table `apache_logs`
--
ALTER TABLE `apache_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_code` (`code`),
  ADD KEY `fk_version` (`version`),
  ADD KEY `fk_method_request` (`method_request`),
  ADD KEY `fk_domain` (`domain`),
  ADD KEY `user_agent` (`user_agent`),
  ADD KEY `ip_log_time` (`ip`,`log_time`),
  ADD KEY `ip_code` (`ip`,`code`);

--
-- Indexes for table `apache_logs_code`
--
ALTER TABLE `apache_logs_code`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `apache_logs_domain`
--
ALTER TABLE `apache_logs_domain`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `domain` (`domain`);

--
-- Indexes for table `apache_logs_method_request`
--
ALTER TABLE `apache_logs_method_request`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `method_request` (`method_request`);

--
-- Indexes for table `apache_logs_version`
--
ALTER TABLE `apache_logs_version`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `version` (`version`);

--
-- Indexes for table `aut`
--
ALTER TABLE `aut`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `login_user` (`login_user`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `bad_user_agents`
--
ALTER TABLE `bad_user_agents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `cpu_analysis`
--
ALTER TABLE `cpu_analysis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cpu_analysis_fk_domain` (`domain`),
  ADD KEY `cpu_analysis_fk_extension` (`extension`),
  ADD KEY `ip` (`ip`);

--
-- Indexes for table `cpu_analysis_uniq_log_time`
--
ALTER TABLE `cpu_analysis_uniq_log_time`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cpu_logs`
--
ALTER TABLE `cpu_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cpu_logs_fk_domain` (`domain`),
  ADD KEY `cpu_logs_fk_command` (`command`),
  ADD KEY `cpu_logs_fk_extension` (`extension`);

--
-- Indexes for table `cpu_logs_command`
--
ALTER TABLE `cpu_logs_command`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `command` (`command`);

--
-- Indexes for table `cpu_logs_file_extension`
--
ALTER TABLE `cpu_logs_file_extension`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `extension` (`extension`);

--
-- Indexes for table `filters`
--
ALTER TABLE `filters`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ip_black_list`
--
ALTER TABLE `ip_black_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ip_white_list`
--
ALTER TABLE `ip_white_list`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ram_key_value`
--
ALTER TABLE `ram_key_value`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key` (`key_data`);

--
-- Indexes for table `test_table`
--
ALTER TABLE `test_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `apache_analysis`
--
ALTER TABLE `apache_analysis`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `apache_analysis_domain`
--
ALTER TABLE `apache_analysis_domain`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `apache_analysis_ml`
--
ALTER TABLE `apache_analysis_ml`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `apache_logs`
--
ALTER TABLE `apache_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `apache_logs_code`
--
ALTER TABLE `apache_logs_code`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `apache_logs_domain`
--
ALTER TABLE `apache_logs_domain`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `apache_logs_method_request`
--
ALTER TABLE `apache_logs_method_request`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `apache_logs_version`
--
ALTER TABLE `apache_logs_version`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `aut`
--
ALTER TABLE `aut`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `bad_user_agents`
--
ALTER TABLE `bad_user_agents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `cpu_analysis`
--
ALTER TABLE `cpu_analysis`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `cpu_analysis_uniq_log_time`
--
ALTER TABLE `cpu_analysis_uniq_log_time`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `cpu_logs`
--
ALTER TABLE `cpu_logs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `cpu_logs_command`
--
ALTER TABLE `cpu_logs_command`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `cpu_logs_file_extension`
--
ALTER TABLE `cpu_logs_file_extension`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ip_black_list`
--
ALTER TABLE `ip_black_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ip_white_list`
--
ALTER TABLE `ip_white_list`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ram_key_value`
--
ALTER TABLE `ram_key_value`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `test_table`
--
ALTER TABLE `test_table`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `apache_analysis_domain`
--
ALTER TABLE `apache_analysis_domain`
  ADD CONSTRAINT `apache_analysis_domain_fk_domain` FOREIGN KEY (`domain`) REFERENCES `apache_logs_domain` (`id`);

--
-- Constraints for table `apache_logs`
--
ALTER TABLE `apache_logs`
  ADD CONSTRAINT `fk_code` FOREIGN KEY (`code`) REFERENCES `apache_logs_code` (`id`),
  ADD CONSTRAINT `fk_domain` FOREIGN KEY (`domain`) REFERENCES `apache_logs_domain` (`id`),
  ADD CONSTRAINT `fk_method_request` FOREIGN KEY (`method_request`) REFERENCES `apache_logs_method_request` (`id`),
  ADD CONSTRAINT `fk_version` FOREIGN KEY (`version`) REFERENCES `apache_logs_version` (`id`);

--
-- Constraints for table `cpu_analysis`
--
ALTER TABLE `cpu_analysis`
  ADD CONSTRAINT `cpu_analysis_fk_domain` FOREIGN KEY (`domain`) REFERENCES `apache_logs_domain` (`id`),
  ADD CONSTRAINT `cpu_analysis_fk_extension` FOREIGN KEY (`extension`) REFERENCES `cpu_logs_file_extension` (`id`);

--
-- Constraints for table `cpu_logs`
--
ALTER TABLE `cpu_logs`
  ADD CONSTRAINT `cpu_logs_fk_command` FOREIGN KEY (`command`) REFERENCES `cpu_logs_command` (`id`),
  ADD CONSTRAINT `cpu_logs_fk_domain` FOREIGN KEY (`domain`) REFERENCES `apache_logs_domain` (`id`),
  ADD CONSTRAINT `cpu_logs_fk_extension` FOREIGN KEY (`extension`) REFERENCES `cpu_logs_file_extension` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
