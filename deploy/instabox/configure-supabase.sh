#!/usr/bin/env bash
set -euo pipefail
umask 077
config="${HOME}/.config/kuisora/app.env"
if [ ! -f "$config" ]; then
  printf '%s\n' 'Konfigurasi Kuisora tidak ditemukan. Hubungi pengelola aplikasi.' >&2
  exit 1
fi
printf '%s' 'Tempel Supabase Secret Key, lalu tekan Enter (karakter tidak ditampilkan): '
IFS= read -r -s KUISORA_SUPABASE_SECRET
printf '\n'
case "$KUISORA_SUPABASE_SECRET" in
  sb_secret_*|eyJ*) ;;
  *) printf '%s\n' 'Format kunci tidak dikenali. Gunakan Secret key Supabase, bukan Publishable key.' >&2; exit 1 ;;
esac
export KUISORA_SUPABASE_SECRET
python3 - "$config" <<'PY'
import os, pathlib, sys, tempfile
path = pathlib.Path(sys.argv[1])
secret = os.environ['KUISORA_SUPABASE_SECRET']
if '\n' in secret or '\r' in secret:
    raise SystemExit('Kunci tidak valid')
lines = path.read_text().splitlines()
updated = False
for index, line in enumerate(lines):
    if line.startswith('SUPABASE_SECRET_KEY='):
        lines[index] = 'SUPABASE_SECRET_KEY=' + secret
        updated = True
if not updated:
    lines.append('SUPABASE_SECRET_KEY=' + secret)
fd, temp_name = tempfile.mkstemp(prefix='.app-env-', dir=path.parent)
try:
    with os.fdopen(fd, 'w') as output:
        output.write('\n'.join(lines) + '\n')
    os.chmod(temp_name, 0o600)
    os.replace(temp_name, path)
finally:
    if os.path.exists(temp_name):
        os.unlink(temp_name)
PY
unset KUISORA_SUPABASE_SECRET
systemctl --user restart kuisora-app.service
printf '%s\n' 'Kunci tersimpan di server dan Kuisora sudah dimulai ulang.'
