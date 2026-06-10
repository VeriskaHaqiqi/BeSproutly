-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 08, 2026 at 09:48 AM
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
-- Database: `sproutlymob_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` longtext NOT NULL,
  `cover_image` varchar(255) DEFAULT NULL,
  `status` enum('draft','published') NOT NULL DEFAULT 'published',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `user_id`, `category_id`, `title`, `content`, `cover_image`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'Cara Merawat Monstera Deliciosa agar Tumbuh Subur', 'Monstera deliciosa adalah tanaman hias yang sangat populer. Untuk merawatnya, pastikan mendapat cahaya matahari tidak langsung yang cukup, siram hanya ketika tanah bagian atas terasa kering, dan bersihkan daunnya secara berkala agar fotosintesis maksimal.', NULL, 'published', '2026-06-08 05:48:55', '2026-06-08 05:48:55'),
(2, 3, 3, 'Mengatasi Hama Kutu Putih Secara Alami', 'Kutu putih sering menyerang tanaman hias dan sayuran. Anda bisa mengatasinya secara alami menggunakan campuran air hangat, sabun cuci piring organik, dan minyak nimba (neem oil). Semprotkan larutan ini ke area yang terserang pada sore hari.', NULL, 'published', '2026-06-08 05:48:55', '2026-06-08 05:48:55');

-- --------------------------------------------------------

--
-- Table structure for table `article_categories`
--

CREATE TABLE `article_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `article_categories`
--

INSERT INTO `article_categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Indoor Plants', NULL, NULL),
(2, 'Outdoor Plants', NULL, NULL),
(3, 'Pest Control', NULL, NULL),
(4, 'Hydroponics', NULL, NULL),
(5, 'Soil Science', NULL, NULL),
(6, 'Crop Management', NULL, NULL),
(7, 'Technology', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `bookmarked_articles`
--

CREATE TABLE `bookmarked_articles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `article_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chat_messages`
--

CREATE TABLE `chat_messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultation_id` bigint(20) UNSIGNED NOT NULL,
  `sender_id` bigint(20) UNSIGNED NOT NULL,
  `message` text DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `message_type` enum('text','image','video') NOT NULL DEFAULT 'text',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `consultations`
--

CREATE TABLE `consultations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `expert_id` bigint(20) UNSIGNED NOT NULL,
  `topic` varchar(200) DEFAULT NULL,
  `fee` decimal(10,2) NOT NULL,
  `status` enum('waiting_payment','waiting_verification','active','completed','rejected') NOT NULL DEFAULT 'waiting_payment',
  `started_at` timestamp NULL DEFAULT NULL,
  `scheduled_end_at` timestamp NULL DEFAULT NULL,
  `ended_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expert_profiles`
--

CREATE TABLE `expert_profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `university` varchar(150) DEFAULT NULL,
  `years_of_experience` int(11) NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `certificate` varchar(255) DEFAULT NULL,
  `diploma` varchar(255) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_holder` varchar(100) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `session_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `session_duration` int(11) NOT NULL DEFAULT 30,
  `instant_booking` tinyint(1) NOT NULL DEFAULT 0,
  `availability_status` enum('available','unavailable') NOT NULL DEFAULT 'unavailable',
  `average_rating` decimal(3,2) NOT NULL DEFAULT 0.00,
  `total_consultations` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `expert_profiles`
--

INSERT INTO `expert_profiles` (`id`, `user_id`, `university`, `years_of_experience`, `description`, `certificate`, `diploma`, `bank_name`, `account_holder`, `account_number`, `session_fee`, `session_duration`, `instant_booking`, `availability_status`, `average_rating`, `total_consultations`, `created_at`, `updated_at`) VALUES
(1, 2, 'Institut Pertanian Bogor', 5, 'Spesialis tanaman hias, hortikultura, dan penanggulangan hama tanaman.', NULL, NULL, 'BCA', 'Dr. Green', '1234567890', 50000.00, 30, 0, 'available', 0.00, 0, '2026-06-08 05:48:54', '2026-06-08 05:48:54'),
(2, 3, 'Hogwarts University', 15, 'Pakar herbologi, kultur jaringan, dan kesehatan tanah organik.', NULL, NULL, 'Mandiri', 'Prof. Sprout', '0987654321', 75000.00, 45, 0, 'available', 0.00, 0, '2026-06-08 05:48:55', '2026-06-08 05:48:55'),
(3, 5, 'Universitas Airlangga', 0, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 30, 0, 'unavailable', 0.00, 0, '2026-06-08 06:21:15', '2026-06-08 06:21:15');

-- --------------------------------------------------------

--
-- Table structure for table `expert_schedules`
--

CREATE TABLE `expert_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `expert_id` bigint(20) UNSIGNED NOT NULL,
  `day` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '2026_05_17_153528_create_expert_profiles_table', 1),
(3, '2026_05_17_153543_create_article_categories_table', 1),
(4, '2026_05_17_153601_create_articles_table', 1),
(5, '2026_05_17_153622_create_bookmarked_articles_table', 1),
(6, '2026_05_17_153637_create_consultations_table', 1),
(7, '2026_05_17_153653_create_payments_table', 1),
(8, '2026_05_17_153710_create_chat_messages_table', 1),
(9, '2026_05_17_153732_create_ratings_table', 1),
(10, '2026_05_17_153746_create_expert_schedules_table', 1),
(11, '2026_05_17_153808_create_specializations_table', 1),
(12, '2026_05_17_160241_create_personal_access_tokens_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultation_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `platform_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) NOT NULL DEFAULT 'bank_transfer',
  `payment_proof` varchar(255) DEFAULT NULL,
  `status` enum('pending','verified','rejected') NOT NULL DEFAULT 'pending',
  `rejection_note` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(9, 'App\\Models\\User', 4, 'auth_token', 'a69a5b02bea960379005dbdaa3c318bed2aa78da5e7216367f184fa636c1c014', '[\"*\"]', '2026-06-08 07:43:39', NULL, '2026-06-08 07:40:18', '2026-06-08 07:43:39'),
(10, 'App\\Models\\User', 5, 'auth_token', '399faa79aa7f83643a512215b0aef978b39df8227c7d7f0d67812e4e042b38c8', '[\"*\"]', '2026-06-08 07:44:19', NULL, '2026-06-08 07:44:16', '2026-06-08 07:44:19');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `consultation_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `expert_id` bigint(20) UNSIGNED NOT NULL,
  `score` tinyint(3) UNSIGNED NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `specializations`
--

CREATE TABLE `specializations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `expert_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','expert') NOT NULL DEFAULT 'user',
  `profile_photo` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `phone`, `gender`, `password`, `role`, `profile_photo`, `google_id`, `email_verified_at`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'User Biasa', 'user@gmail.com', '081234567890', 'Male', '$2y$12$SSrp8x1RiimdT.XqykSgyeSJXY8Jjdqqg4Vv8fYGhhV01vhVgTlSS', 'user', NULL, NULL, NULL, NULL, '2026-06-08 05:48:54', '2026-06-08 05:48:54'),
(2, 'Dr. Green (Expert)', 'expert@gmail.com', '089876543210', 'Female', '$2y$12$0Uh16TaCrQ5HfU1w/UZxme6/iaPYNchwbGj98Ju7K243tXwZXYvPK', 'expert', NULL, NULL, NULL, NULL, '2026-06-08 05:48:54', '2026-06-08 05:48:54'),
(3, 'Prof. Sprout', 'sprout@gmail.com', '081122334455', 'Male', '$2y$12$8hYCloo3zda16ElK0wPkO.9PAiOzUcPBnN.ID5LRULFuQQ5V2JKou', 'expert', NULL, NULL, NULL, NULL, '2026-06-08 05:48:55', '2026-06-08 05:48:55'),
(4, 'Sarah Johnson', 'sarah@example.com', '081234567890', 'Female', '$2y$12$i/dwMZq5GyQn2TRAVGwxpeKYTwLvF7I23ZHpf06Gg8zgFoDXOpCUW', 'user', NULL, NULL, NULL, NULL, '2026-06-08 06:15:13', '2026-06-08 06:15:13'),
(5, 'Dr. Sarah Chen', 'sarah.chen@example.com', '081234567890', 'Female', '$2y$12$qVJxWrxX2T0l2cPS6TvTOuTapvtNI.RyvDGfdLGGKo56TbtZfmW06', 'expert', NULL, NULL, NULL, NULL, '2026-06-08 06:21:15', '2026-06-08 06:21:15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `articles_user_id_foreign` (`user_id`),
  ADD KEY `articles_category_id_foreign` (`category_id`);

--
-- Indexes for table `article_categories`
--
ALTER TABLE `article_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookmarked_articles`
--
ALTER TABLE `bookmarked_articles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bookmarked_articles_user_id_article_id_unique` (`user_id`,`article_id`),
  ADD KEY `bookmarked_articles_article_id_foreign` (`article_id`);

--
-- Indexes for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_messages_consultation_id_foreign` (`consultation_id`),
  ADD KEY `chat_messages_sender_id_foreign` (`sender_id`);

--
-- Indexes for table `consultations`
--
ALTER TABLE `consultations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `consultations_user_id_foreign` (`user_id`),
  ADD KEY `consultations_expert_id_foreign` (`expert_id`);

--
-- Indexes for table `expert_profiles`
--
ALTER TABLE `expert_profiles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expert_profiles_user_id_foreign` (`user_id`);

--
-- Indexes for table `expert_schedules`
--
ALTER TABLE `expert_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expert_schedules_expert_id_foreign` (`expert_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_consultation_id_foreign` (`consultation_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ratings_consultation_id_unique` (`consultation_id`),
  ADD KEY `ratings_user_id_foreign` (`user_id`),
  ADD KEY `ratings_expert_id_foreign` (`expert_id`);

--
-- Indexes for table `specializations`
--
ALTER TABLE `specializations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `specializations_expert_id_foreign` (`expert_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `article_categories`
--
ALTER TABLE `article_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `bookmarked_articles`
--
ALTER TABLE `bookmarked_articles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat_messages`
--
ALTER TABLE `chat_messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `consultations`
--
ALTER TABLE `consultations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expert_profiles`
--
ALTER TABLE `expert_profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `expert_schedules`
--
ALTER TABLE `expert_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `specializations`
--
ALTER TABLE `specializations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `articles_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `article_categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `articles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bookmarked_articles`
--
ALTER TABLE `bookmarked_articles`
  ADD CONSTRAINT `bookmarked_articles_article_id_foreign` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookmarked_articles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `chat_messages_consultation_id_foreign` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `consultations`
--
ALTER TABLE `consultations`
  ADD CONSTRAINT `consultations_expert_id_foreign` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `consultations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `expert_profiles`
--
ALTER TABLE `expert_profiles`
  ADD CONSTRAINT `expert_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `expert_schedules`
--
ALTER TABLE `expert_schedules`
  ADD CONSTRAINT `expert_schedules_expert_id_foreign` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_consultation_id_foreign` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_consultation_id_foreign` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_expert_id_foreign` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `specializations`
--
ALTER TABLE `specializations`
  ADD CONSTRAINT `specializations_expert_id_foreign` FOREIGN KEY (`expert_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
