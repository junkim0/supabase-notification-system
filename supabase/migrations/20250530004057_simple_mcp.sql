-- Simple MCP for notification routing
create type notification_channel as enum ('email', 'sms', 'in_app');
create type notification_priority as enum ('low', 'normal', 'high');

-- Main notifications queue
create table public.notification_queue (
    id uuid default uuid_generate_v4() primary key,
    recipient_id uuid references auth.users(id) on delete cascade,
    channel notification_channel not null,
    subject text not null,
    content text not null,
    priority notification_priority default 'normal',
    status text not null default 'pending' check (status in ('pending', 'processing', 'sent', 'failed')),
    retry_count integer default 0,
    created_at timestamptz default now(),
    processed_at timestamptz
);

-- Notification history for tracking
create table public.notification_history (
    id uuid default uuid_generate_v4() primary key,
    notification_id uuid references public.notification_queue(id) on delete cascade,
    status text not null,
    error_message text,
    processed_at timestamptz default now()
);

-- Enable RLS
alter table public.notification_queue enable row level security;
alter table public.notification_history enable row level security;

-- RLS policies
create policy "Users can view their own notifications"
    on public.notification_queue
    for select
    using (auth.uid() = recipient_id);

create policy "System can manage all notifications"
    on public.notification_queue
    for all
    using (auth.uid() in (select id from auth.users where email like '%@system.local'));

-- Function to process notifications
create or replace function process_notification()
returns trigger as $$
begin
    -- Simulate processing delay
    perform pg_sleep(0.1);
    
    -- Update status based on channel (simulating external service calls)
    update public.notification_queue
    set status = 
        case 
            when channel = 'in_app' then 'sent'  -- Always succeeds
            when channel = 'email' then 
                case when random() > 0.1 then 'sent' else 'failed' end  -- 90% success
            when channel = 'sms' then 
                case when random() > 0.2 then 'sent' else 'failed' end  -- 80% success
        end,
    processed_at = now(),
    retry_count = retry_count + 1
    where id = new.id;

    -- Record in history
    insert into public.notification_history (notification_id, status, error_message)
    select 
        new.id,
        status,
        case when status = 'failed' then 'External service error' else null end
    from public.notification_queue
    where id = new.id;

    return new;
end;
$$ language plpgsql security definer;

-- Trigger for processing new notifications
create trigger process_new_notification
    after insert on public.notification_queue
    for each row
    when (new.status = 'pending')
    execute function process_notification();

-- Helper function to send notification
create or replace function send_notification(
    p_recipient_id uuid,
    p_channel notification_channel,
    p_subject text,
    p_content text,
    p_priority notification_priority default 'normal'
)
returns uuid as $$
declare
    v_notification_id uuid;
begin
    insert into public.notification_queue
        (recipient_id, channel, subject, content, priority)
    values
        (p_recipient_id, p_channel, p_subject, p_content, p_priority)
    returning id into v_notification_id;
    
    return v_notification_id;
end;
$$ language plpgsql security definer; 