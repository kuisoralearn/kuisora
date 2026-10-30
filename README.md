# Kuisora

Aplikasi kuis interaktif berbahasa Indonesia. Versi ini menggunakan Next.js pada server Node.js dan Supabase untuk data serta gambar. Cloudflare Tunnel dapat meneruskan domain ke port aplikasi di VPS.

## Konfigurasi

Butuh Node.js 22.13+ dan pnpm 11.25.0. Buat salinan `.env.example` sebagai `.env.local` pada server dan isi nilainya secara privat:

- `SUPABASE_URL`: URL project Supabase.
- `SUPABASE_SECRET_KEY`: secret key Supabase untuk server; jangan beri prefix `NEXT_PUBLIC_` dan jangan masukkan ke Git.
- `APP_ORIGINS`: URL HTTPS yang diizinkan, dipisahkan koma. Contoh: `https://kuisora.biz.id,https://www.kuisora.biz.id`.
- `GOOGLE_CLIENT_ID`: OAuth Client ID tipe Web untuk tombol Google. Daftarkan kedua URL domain sebagai Authorized JavaScript origins. Tidak diperlukan OAuth redirect URI untuk tombol ini.
- `GEMINI_API_KEY`: kunci Gemini, opsional. Simpan di server.
- `GEMINI_MODEL`: opsional, default `gemini-2.5-flash`.

```bash
pnpm install --frozen-lockfile
pnpm build
pnpm start
```

Server mendengarkan `127.0.0.1:3000` untuk dipakai oleh reverse proxy atau Cloudflare Tunnel. Untuk pengembangan lokal jalankan `pnpm dev` dan tambahkan `http://localhost:3000` ke `APP_ORIGINS` dan ke origin OAuth jika diperlukan.

## Supabase

Migrasi ada di `supabase/migrations`. Kuis, sesi, peserta, jawaban, sesi login, dan pemakaian AI hanya diakses server. RLS aktif dan tidak ada akses langsung dari role `anon` maupun `authenticated`. Bucket `kuisora-images` bersifat private, maksimal 4 MB per file, dan hanya menerima PNG, JPEG, WebP. API memeriksa pemilik dan akses kuis sebelum menyajikan gambar. Fungsi database untuk mencatat jawaban dan penggunaan AI hanya dapat dijalankan server dengan `service_role`.

Project Supabase yang sudah disiapkan memiliki migrasi `20261030030918_kuisora_backend` dan `20261030065612_kuisora_runtime`. Jangan jalankan ulang file yang sudah tercatat di project yang sama. Untuk project baru, terapkan migrasi dengan Supabase CLI.

## Fitur dan batasan

- Editor kuis manual, kuis publik/private, pembuatan draf AI, sesi PIN, dan mode kelas tanpa perangkat siswa.
- Ekspor DOCX dan kunci jawaban. DOCX dapat diunggah ke Google Docs; ekspor langsung ke Drive belum tersedia.
- Login Google dan AI membutuhkan nilai konfigurasi masing-masing. Tinjau soal hasil AI sebelum digunakan.
- Sesi menggunakan polling 1,5 detik dengan batas 100 peserta. Belum ada uji beban produksi.
- Sandbox Instabox pada paket gratis dapat pause ketika idle dan memiliki batas waktu berjalan; domain tidak tersedia ketika sandbox berhenti.

## Instabox

For `instabox-1`, copy `deploy/instabox/kuisora-app.service` to `~/.config/systemd/user/` and put the server environment in `~/.config/kuisora/app.env` with permissions `600`. This environment file has the same keys as `.env.example` in `KEY=value` form. After adding or rotating credentials, restart with `systemctl --user restart kuisora-app.service`. The Cloudflare Tunnel is managed separately and routes the domain to port 3000. It does not keep a free sandbox awake.
