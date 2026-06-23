-- Run this in Supabase: Dashboard > SQL Editor > New query > paste all > Run

create table tickets (
  id bigint generated always as identity primary key,
  ticket_code text unique,
  property text not null,
  unit text,
  area text not null,
  reporter text,
  summary text not null,
  description text,
  priority text not null default 'Medium',
  access text,
  entry text,
  resolved boolean not null default false,
  created_at timestamptz not null default now()
);

-- Auto-generate TKT-0001, TKT-0002, ... codes
create sequence tickets_code_seq;

create or replace function set_ticket_code()
returns trigger as $$
begin
  new.ticket_code := 'TKT-' || lpad(nextval('tickets_code_seq')::text, 4, '0');
  return new;
end;
$$ language plpgsql;

create trigger trg_set_ticket_code
before insert on tickets
for each row execute function set_ticket_code();

-- Enable Row Level Security
alter table tickets enable row level security;

-- Allow anyone (including anonymous users via the public anon key) to
-- read, insert, update, and delete tickets. This matches a simple
-- "anyone with the link can use the ticket system" setup.
-- Tighten these later if you want to require login (see README).
create policy "public read" on tickets for select using (true);
create policy "public insert" on tickets for insert with check (true);
create policy "public update" on tickets for update using (true);
create policy "public delete" on tickets for delete using (true);

-- Enable realtime so all open browser tabs stay in sync automatically
alter publication supabase_realtime add table tickets;
