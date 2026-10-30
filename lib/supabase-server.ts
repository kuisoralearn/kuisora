import { createClient, type SupabaseClient } from '@supabase/supabase-js';

let client: SupabaseClient | undefined;

/** This client is used only by server routes. The secret must never reach a browser. */
export function serverSupabase(): SupabaseClient {
  const url = process.env.SUPABASE_URL;
  const secret = process.env.SUPABASE_SECRET_KEY;
  if (!url || !secret) {
    throw Object.assign(new Error('Backend Supabase belum dikonfigurasi.'), { status: 503 });
  }
  if (!client) client = createClient(url, secret, { auth: { persistSession: false, autoRefreshToken: false } });
  return client;
}

export function checked<T>(result: { data: T; error: { message: string } | null }): T {
  if (result.error) {
    console.error('Supabase request failed:', result.error.message);
    throw new Error('Layanan data belum dapat memproses permintaan.');
  }
  return result.data;
}
