-- First, create users in auth.users
insert into auth.users (id, email)
values
  ('d0fc7e7c-6d7c-4e1a-a103-9e9c4ed12345', 'john@example.com'),
  ('b6e3b5a4-5c2d-4e1f-8b9a-9e9c4ed67890', 'jane@example.com'),
  ('a1b2c3d4-5e6f-4e5f-8e9f-9e9c4ed11111', 'bob@example.com'),
  ('00000000-0000-0000-0000-000000000001', 'system@system.local');

-- Then insert into public.users
insert into public.users (id, username, full_name, avatar_url)
values
  ('d0fc7e7c-6d7c-4e1a-a103-9e9c4ed12345', 'johndoe', 'John Doe', 'https://api.dicebear.com/7.x/avataaars/svg?seed=john'),
  ('b6e3b5a4-5c2d-4e1f-8b9a-9e9c4ed67890', 'janedoe', 'Jane Doe', 'https://api.dicebear.com/7.x/avataaars/svg?seed=jane'),
  ('a1b2c3d4-5e6f-4e5f-8e9f-9e9c4ed11111', 'bobsmith', 'Bob Smith', 'https://api.dicebear.com/7.x/avataaars/svg?seed=bob');

-- Insert sample teams
insert into public.teams (id, name, description, created_by)
values
  ('f47ac10b-58cc-4372-a567-0e02b2c3d479', 'Engineering Team', 'Our awesome engineering team', 'd0fc7e7c-6d7c-4e1a-a103-9e9c4ed12345'),
  ('8f9aa5bb-7dec-4add-8a3a-5c1f1f6def78', 'Marketing Team', 'Creative marketing professionals', 'b6e3b5a4-5c2d-4e1f-8b9a-9e9c4ed67890'),
  ('c6d0c728-2624-4411-8e82-7a1f1f6def12', 'Design Team', 'UI/UX design experts', 'a1b2c3d4-5e6f-4e5f-8e9f-9e9c4ed11111');

-- Insert sample posts
insert into public.posts (id, title, content, author_id, team_id)
values
  ('d290f1ee-6c54-4b01-90e6-d701748f0851', 'Welcome to Engineering!', 'Hello everyone! Excited to start our engineering journey together.', 'd0fc7e7c-6d7c-4e1a-a103-9e9c4ed12345', 'f47ac10b-58cc-4372-a567-0e02b2c3d479'),
  ('04d6a387-957c-4d35-9f57-77ce3a0f5932', 'Marketing Strategy 2024', 'Our marketing goals and objectives for the upcoming year.', 'b6e3b5a4-5c2d-4e1f-8b9a-9e9c4ed67890', '8f9aa5bb-7dec-4add-8a3a-5c1f1f6def78'),
  ('098f6bcd-4621-3373-8ade-4e832627b4f6', 'New Design System', 'Introducing our new design system components.', 'a1b2c3d4-5e6f-4e5f-8e9f-9e9c4ed11111', 'c6d0c728-2624-4411-8e82-7a1f1f6def12'),
  ('7b1f1f6d-ef78-4411-8e82-c6d0c7282624', 'Project Updates', 'Weekly progress report on our current projects.', 'd0fc7e7c-6d7c-4e1a-a103-9e9c4ed12345', 'f47ac10b-58cc-4372-a567-0e02b2c3d479');

-- Send some test notifications
select send_notification(
    'd0fc7e7c-6d7c-4e1a-a103-9e9c4ed12345',
    'email'::notification_channel,
    'Welcome to the platform!',
    'Hi John, welcome to our platform. We''re excited to have you here!',
    'normal'::notification_priority
);

select send_notification(
    'b6e3b5a4-5c2d-4e1f-8b9a-9e9c4ed67890',
    'sms'::notification_channel,
    'Login Alert',
    'New login detected from your account',
    'high'::notification_priority
);

select send_notification(
    'a1b2c3d4-5e6f-4e5f-8e9f-9e9c4ed11111',
    'in_app'::notification_channel,
    'Task Assignment',
    'You have been assigned a new task: Review documentation',
    'low'::notification_priority
); 