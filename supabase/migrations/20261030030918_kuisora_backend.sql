create table public.quizzes (id text primary key, owner text not null, title text not null, visibility text not null default 'private' check (visibility in ('private','public')), data text not null, updated bigint not null);
create index quizzes_owner_updated_idx on public.quizzes (owner, updated desc);
create index quizzes_visibility_updated_idx on public.quizzes (visibility, updated desc);
create table public.sessions (id text primary key, pin text not null unique check (pin ~ '^[0-9]{6}$'), owner text not null, data text not null, updated bigint not null);
create index sessions_owner_updated_idx on public.sessions (owner, updated desc);
create table public.participants (id text primary key, session text not null references public.sessions(id) on delete cascade, token text not null unique, name text not null, joined bigint not null);
create index participants_session_joined_idx on public.participants (session, joined);
create table public.answers (id text primary key, session text not null references public.sessions(id) on delete cascade, participant text not null references public.participants(id) on delete cascade, question integer not null check (question >= 0), choice integer not null check (choice >= 0), correct integer not null check (correct in (0,1)), points integer not null check (points >= 0), created bigint not null, constraint one_answer unique (session, participant, question));
create index answers_session_question_idx on public.answers (session, question);
create table public.auth_sessions (token text primary key, "user" text not null, name text not null, email text not null, expires bigint not null);
create index auth_sessions_user_expires_idx on public.auth_sessions ("user", expires);
create table public.ai_usage (id text primary key, count integer not null default 0 check (count >= 0));
alter table public.quizzes enable row level security;
alter table public.sessions enable row level security;
alter table public.participants enable row level security;
alter table public.answers enable row level security;
alter table public.auth_sessions enable row level security;
alter table public.ai_usage enable row level security;
revoke all on public.quizzes, public.sessions, public.participants, public.answers, public.auth_sessions, public.ai_usage from anon, authenticated;
grant all on public.quizzes, public.sessions, public.participants, public.answers, public.auth_sessions, public.ai_usage to service_role;
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('kuisora-images', 'kuisora-images', false, 4194304, array['image/png','image/jpeg','image/webp'])
on conflict (id) do update set public=false, file_size_limit=excluded.file_size_limit, allowed_mime_types=excluded.allowed_mime_types;
