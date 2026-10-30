CREATE TABLE `ai_usage` (
	`id` text PRIMARY KEY NOT NULL,
	`count` integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE `answers` (
	`id` text PRIMARY KEY NOT NULL,
	`session` text NOT NULL,
	`participant` text NOT NULL,
	`question` integer NOT NULL,
	`choice` integer NOT NULL,
	`correct` integer NOT NULL,
	`points` integer NOT NULL,
	`created` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `one_answer` ON `answers` (`session`,`participant`,`question`);--> statement-breakpoint
CREATE TABLE `auth_sessions` (
	`token` text PRIMARY KEY NOT NULL,
	`user` text NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`expires` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `participants` (
	`id` text PRIMARY KEY NOT NULL,
	`session` text NOT NULL,
	`token` text NOT NULL,
	`name` text NOT NULL,
	`joined` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `quizzes` (
	`id` text PRIMARY KEY NOT NULL,
	`owner` text NOT NULL,
	`title` text NOT NULL,
	`visibility` text DEFAULT 'private' NOT NULL,
	`data` text NOT NULL,
	`updated` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `sessions` (
	`id` text PRIMARY KEY NOT NULL,
	`pin` text NOT NULL,
	`owner` text NOT NULL,
	`data` text NOT NULL,
	`updated` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `sessions_pin_unique` ON `sessions` (`pin`);