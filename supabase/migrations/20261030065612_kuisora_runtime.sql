create function public.kuisora_consume_ai_credit(p_id text)
returns integer language plpgsql security invoker set search_path = '' as $$
declare used integer;
begin
  insert into public.ai_usage as usage (id, count) values (p_id, 1)
  on conflict (id) do update set count = usage.count + 1 where usage.count < 20
  returning count into used;
  return coalesce(used, 0);
end;
$$;

create function public.kuisora_submit_answer(
  p_id text, p_session text, p_participant text, p_question integer,
  p_choice integer, p_correct integer, p_points integer, p_now bigint
) returns boolean language plpgsql security invoker set search_path = '' as $$
declare session_data jsonb; changed integer; current_ms bigint;
begin
  select data::jsonb into session_data from public.sessions where id = p_session for update;
  current_ms := greatest(p_now, floor(extract(epoch from clock_timestamp()) * 1000)::bigint);
  if session_data is null or session_data->>'phase' <> 'question'
     or (session_data->>'index')::integer <> p_question
     or (session_data->>'deadline')::bigint <= current_ms
     or session_data->>'deadline' is null
     or not exists (select 1 from public.participants where id = p_participant and session = p_session) then
    return false;
  end if;
  insert into public.answers (id, session, participant, question, choice, correct, points, created)
  values (p_id, p_session, p_participant, p_question, p_choice, p_correct, p_points, current_ms)
  on conflict (session, participant, question) do nothing;
  get diagnostics changed = row_count;
  return changed = 1;
end;
$$;

revoke all on function public.kuisora_consume_ai_credit(text) from public, anon, authenticated;
revoke all on function public.kuisora_submit_answer(text,text,text,integer,integer,integer,integer,bigint) from public, anon, authenticated;
grant execute on function public.kuisora_consume_ai_credit(text) to service_role;
grant execute on function public.kuisora_submit_answer(text,text,text,integer,integer,integer,integer,bigint) to service_role;
