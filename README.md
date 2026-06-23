# Maintenance Hub — Setup Guide

This turns your single-user, localStorage-only page into a real shared app:
multiple people can submit tickets and see/update the same live queue,
hosted for free on GitHub Pages with a free Supabase database as the backend.

## 1. Create the database (Supabase — free tier)

1. Go to https://supabase.com → sign up → **New project**.
2. Once it's created, open **SQL Editor** (left sidebar) → **New query**.
3. Paste the entire contents of `schema.sql` (included here) and click **Run**.
   This creates the `tickets` table, auto-generated ticket IDs (TKT-0001, etc.),
   and turns on realtime sync.
4. Go to **Project Settings → API**. Copy two values:
   - **Project URL**
   - **anon public key**

## 2. Connect the website to the database

1. Open `index.html` and find these two lines near the top of the `<script>` tag:
   ```js
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
2. Replace them with the values you copied in step 1.4.
3. Save the file.

The anon key is meant to be public (it's used in client-side apps everywhere) —
access control happens via the database's Row Level Security policies, which
`schema.sql` already sets up to allow anyone to read/write tickets. If you
later want to require people to log in before submitting/viewing tickets, see
**Optional: adding login** below.

## 3. Push to GitHub

```bash
cd maintenance-tickets        # your repo folder
cp /path/to/index.html .
cp /path/to/schema.sql .       # optional, just for reference/history
git add .
git commit -m "Add maintenance ticket app with Supabase backend"
git push origin main
```

## 4. Turn on GitHub Pages

1. On GitHub, open your repo → **Settings → Pages**.
2. Under "Build and deployment", set **Source** to **Deploy from a branch**.
3. Branch: `main`, folder: `/ (root)` → **Save**.
4. After a minute, GitHub shows your live URL, something like:
   `https://yourusername.github.io/maintenance-tickets/`

Share that link with anyone who needs to submit or manage tickets — they'll
all be reading and writing the same Supabase database, so everyone sees the
same live ticket queue (it updates automatically, no refresh needed, thanks
to Supabase realtime).

## Optional: adding login

Right now anyone with the link can submit, resolve, or delete tickets — fine
for an internal team on a private link, but if you want actual user accounts
(e.g. only verified staff can resolve/delete, or tenants can only see their
own property), Supabase Auth can handle that with email/password or magic
links. That's a bigger change to both the SQL policies and the HTML — let me
know if you want help adding it.

## Costs

Supabase's free tier (500MB database, generous request limits) and GitHub
Pages are both free for a project this size. You will not need a credit card
unless you outgrow the free tier.
