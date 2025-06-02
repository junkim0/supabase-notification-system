-- Create users table (extending Supabase's auth.users)
create table if not exists public.users (
  id uuid references auth.users(id) primary key,
  username text unique not null,
  full_name text,
  avatar_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Create teams table
create table if not exists public.teams (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  description text,
  created_by uuid references public.users(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Create posts table
create table if not exists public.posts (
  id uuid default uuid_generate_v4() primary key,
  title text not null,
  content text not null,
  author_id uuid references public.users(id),
  team_id uuid references public.teams(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Create RLS policies
alter table public.users enable row level security;
alter table public.teams enable row level security;
alter table public.posts enable row level security;

-- Users policies
create policy "Users can view all profiles"
  on public.users for select
  to authenticated
  using (true);

create policy "Users can update their own profile"
  on public.users for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Teams policies
create policy "Anyone can view teams"
  on public.teams for select
  to authenticated
  using (true);

create policy "Team creator can update team"
  on public.teams for update
  to authenticated
  using (auth.uid() = created_by)
  with check (auth.uid() = created_by);

create policy "Authenticated users can create teams"
  on public.teams for insert
  to authenticated
  with check (auth.uid() = created_by);

-- Posts policies
create policy "Anyone can view posts"
  on public.posts for select
  to authenticated
  using (true);

create policy "Authors can update their posts"
  on public.posts for update
  to authenticated
  using (auth.uid() = author_id)
  with check (auth.uid() = author_id);

create policy "Team members can create posts"
  on public.posts for insert
  to authenticated
  with check (auth.uid() = author_id);

-- Create functions to handle updated_at
create or replace function handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Create triggers for updated_at
create trigger handle_users_updated_at
  before update on public.users
  for each row
  execute function handle_updated_at();

create trigger handle_teams_updated_at
  before update on public.teams
  for each row
  execute function handle_updated_at();

create trigger handle_posts_updated_at
  before update on public.posts
  for each row
  execute function handle_updated_at();
