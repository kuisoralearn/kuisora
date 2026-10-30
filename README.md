# Kuisora

An Indonesian quiz studio with an animated, responsive dashboard, manual editor, public/private catalog, live PIN sessions, teacher-paced classroom mode, and printable exams.

## Implemented

- D1-backed quizzes with server-enforced ownership; public browse, duplication, and editing of your copies.
- Manual multiple-choice / true-false authoring, duration, explanations, theme covers, and private R2 image upload.
- Live sessions: six-digit PIN / QR / direct link, participant token, lobby lock, server-clock timer, pause/resume/extend, manual reveal and next, accuracy or speed scoring, reconnect, CSV results.
- Teacher classroom mode without student devices, projector window, and optional manual group scoring.
- DOCX export (A4, optional pictures, student identity fields), separate answer keys, shuffled order preserved for the same package, and browser Print / Save as PDF.
- AI workflow for topics, pasted material, and image extraction/generation. Requires an API secret before it is usable; no fabricated fallback output.
- Optional Google Identity Services sign-in with server-verified JWT (Google JWKS, issuer, audience, verified email), hashed seven-day HttpOnly sessions. Existing Sites authentication remains supported.
- Reduced-motion support and mobile layouts.

## Runtime configuration

Sites provisions `DB` (D1) and `BUCKET` (R2) from `.openai/hosting.json` and applies committed Drizzle migrations.

Use Sites environment settings for:

- `GOOGLE_CLIENT_ID`: OAuth client type Web application. Configure the deployed site origin as an Authorized JavaScript origin in Google Auth Platform. The app uses the GIS JavaScript callback; no custom OAuth redirect route is required. This does not bypass the Sites private access boundary.
- `GEMINI_API_KEY`: secret for Google Gemini API. The browser never receives this value.
- `GEMINI_MODEL`: optional, defaults to `gemini-2.5-flash`; select a model available to the account.

Redeploy after environment changes. Do not commit credentials or paste them into browser code.

Quiz visibility is an application setting, separate from Sites audience. The current publication has public site access. Preserve the chosen audience when publishing changes. All host mutations require a valid Sites identity or configured Google identity. Public participants use random scoped tokens. Do a classroom pilot and load test before external launch.

## Product limits

- Live updates use 1.5-second polling, not WebSockets. The pilot cap is 100 participants per session; 40–50 concurrent participants has not been load-tested.
- Active sessions expire after 24 hours of host inactivity. Session results are stored in D1.
- AI: up to 50 generated questions per request, 20 requests/day/host. Teacher review required. Provider credentials, actual provider calls, and Google login cannot be verified without configuration.
- Google Docs direct creation is not implemented. Upload exported DOCX to Google Drive and open it with Google Docs.
- PDF is provided through browser Print / Save as PDF, not a separate server-rendered PDF download.
- Classroom mode is not offline-capable: only student devices are unnecessary. Internet is required on the host.
- Favorites are device-local preferences; quizzes and game results are server-backed.

## Validation

`node --import ./tests/register.mjs tests/integration.mjs` runs the real API handler against an isolated in-memory SQLite adapter, with test-only identities. It checks authorization boundaries, visibility, snapshots, scoring, deadline enforcement, duplicate-answer prevention, and invalid operations. This is a deterministic route/database test, not a production browser or cloud load test.

`node --import ./tests/register.mjs tests/docx.mjs` generates an exam and matching answer key for structural validation.

`node "$SITES_PNPM_BIN" exec tsc --noEmit`

Use the Sites build helper for production builds. The preview is managed by `sites-preview`.
