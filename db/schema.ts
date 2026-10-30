// Intentionally empty by default.
// Add Drizzle tables here when the site actually needs a database.
// See examples/d1/db/schema.ts for an opt-in example.
import { sqliteTable, text, integer, uniqueIndex } from 'drizzle-orm/sqlite-core';
export const quizzes = sqliteTable('quizzes', { id:text('id').primaryKey(), owner:text('owner').notNull(), title:text('title').notNull(), visibility:text('visibility').notNull().default('private'), data:text('data').notNull(), updated:integer('updated').notNull() });
export const sessions = sqliteTable('sessions', { id:text('id').primaryKey(), pin:text('pin').notNull().unique(), owner:text('owner').notNull(), data:text('data').notNull(), updated:integer('updated').notNull() });
export const participants = sqliteTable('participants', { id:text('id').primaryKey(), session:text('session').notNull(), token:text('token').notNull(), name:text('name').notNull(), joined:integer('joined').notNull() });
export const answers = sqliteTable('answers', { id:text('id').primaryKey(), session:text('session').notNull(), participant:text('participant').notNull(), question:integer('question').notNull(), choice:integer('choice').notNull(), correct:integer('correct').notNull(), points:integer('points').notNull(), created:integer('created').notNull() }, t=>[uniqueIndex('one_answer').on(t.session,t.participant,t.question)]);
export const authSessions = sqliteTable('auth_sessions', { token:text('token').primaryKey(), user:text('user').notNull(), name:text('name').notNull(), email:text('email').notNull(), expires:integer('expires').notNull() });
export const aiUsage = sqliteTable('ai_usage', { id:text('id').primaryKey(), count:integer('count').notNull().default(0) });
