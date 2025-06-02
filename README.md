# TaskFlow - Team Collaboration Platform with MCP

TaskFlow is a modern team collaboration platform built with Supabase and Next.js, featuring a powerful Message Control Program (MCP) system for workflow automation and message processing. It provides teams with robust tools for project management, task tracking, and real-time collaboration, enhanced by sophisticated message routing and processing capabilities.

## Features

- **Team Workspaces**: Create and manage multiple team workspaces
- **Project Management**: Organize work into projects with customizable boards
- **Task Tracking**: Drag-and-drop task management with real-time updates
- **Team Collaboration**: Comments, file attachments, and activity tracking
- **Role-Based Access**: Granular control over workspace and project access
- **Real-time Updates**: Live notifications and collaborative features
- **File Management**: Secure file storage and sharing
- **Analytics**: Track team productivity and project progress

### Message Control Program (MCP) Features

- **Message Queues**: Create and manage message queues for different types of workflows
- **Message Processors**: Configure custom processors for filtering, transforming, and routing messages
- **Workflow Automation**: Define complex workflow rules with message routing and processing
- **Dead Letter Queue**: Handle failed messages with retry mechanisms and error tracking
- **Message History**: Track and audit all message processing activities
- **Priority Processing**: Support for priority-based message handling
- **Custom Processors**: Extend the system with custom message processors

## Tech Stack

- **Frontend**: Next.js, React, Tailwind CSS
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Real-time)
- **Authentication**: Supabase Auth with multiple providers
- **Database**: PostgreSQL with Row Level Security
- **Real-time**: Supabase Real-time subscriptions
- **Storage**: Supabase Storage for file management
- **Message Processing**: Custom MCP implementation with PostgreSQL
- **Deployment**: Vercel (Frontend) + Supabase (Backend)

## Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/taskflow.git
   cd taskflow
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up Supabase locally:
   ```bash
   npx supabase start
   ```

4. Create a `.env.local` file:
   ```
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

5. Run the development server:
   ```bash
   npm run dev
   ```

6. Open [http://localhost:3000](http://localhost:3000) in your browser.

## Database Schema

The application uses the following main tables:

### Core Tables
- `workspaces`: Team workspaces
- `workspace_members`: Workspace membership and roles
- `projects`: Projects within workspaces
- `task_lists`: Columns in project boards
- `tasks`: Individual tasks
- `task_assignments`: Task assignments to users
- `comments`: Task comments
- `attachments`: File attachments
- `activity_logs`: System-wide activity tracking

### MCP Tables
- `message_queues`: Manages different types of message queues
- `message_processors`: Defines message processing rules and transformations
- `message_routes`: Configures message routing between queues
- `messages`: Stores messages in the system
- `message_processing_history`: Tracks message processing activities
- `dead_letter_queue`: Handles failed message processing

## Message Processing System

The MCP system provides a robust framework for handling complex workflows:

1. **Message Flow**:
   - Messages enter through designated queues
   - Processors handle message transformation and routing
   - Successfully processed messages move to destination queues
   - Failed messages are sent to the dead letter queue

2. **Processor Types**:
   - Filter: Conditionally process messages
   - Transform: Modify message content
   - Route: Direct messages to different queues
   - Aggregate: Combine multiple messages
   - Custom: Implement custom processing logic

3. **Error Handling**:
   - Automatic retry mechanism
   - Dead letter queue for failed messages
   - Detailed error tracking and logging
   - Manual message recovery options

## Security

- Row Level Security (RLS) policies ensure data access control
- Secure file storage with signed URLs
- Role-based access control for workspaces
- Encrypted data in transit and at rest
- Message-level security and audit trails

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Supabase](https://supabase.com/) - Open source Firebase alternative
- [Next.js](https://nextjs.org/) - React framework
- [Tailwind CSS](https://tailwindcss.com/) - CSS framework
- [DiceBear Avatars](https://www.dicebear.com/) - Avatar generation

# Notification System Test

This is a simple test script to demonstrate the notification system built with Supabase.

## Setup

1. Make sure your local Supabase instance is running:
   ```bash
   npx supabase start
   ```

2. Create a `.env` file with the following content:
   ```
   SUPABASE_URL=http://127.0.0.1:54321
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU
   ```

3. Install dependencies:
   ```bash
   npm install
   ```

## Running the Tests

Run the test script:
```bash
npm test
```

The script will:
1. Send notifications through different channels (email, SMS, in-app)
2. Check the status of each notification
3. List all notifications for a specific user

## Features Demonstrated

- **Multiple Channels**: Test sending notifications via email, SMS, and in-app channels
- **Priority Levels**: Test different priority levels (high, normal, low)
- **Status Tracking**: Monitor notification processing status
- **Error Handling**: See how failed notifications are handled
- **History**: View notification history and processing results

## System Design

The notification system uses:
- PostgreSQL for message queuing and storage
- Row Level Security (RLS) for data access control
- Database triggers for automatic message processing
- Simulated external service calls with configurable success rates

## Expected Output

The test script will output something like:
```
🚀 Starting notification system tests...

Test 1: Sending notifications through different channels...
Email notification sent: 123e4567-e89b-12d3-a456-426614174000
SMS notification sent: 223e4567-e89b-12d3-a456-426614174001
In-app notification sent: 323e4567-e89b-12d3-a456-426614174002

Waiting for notifications to be processed...

Test 2: Checking notification statuses...
Email notification status: sent
SMS notification status: sent
In-app notification status: sent

Test 3: Listing notifications for John...
John's notifications: [
  {
    id: '123e4567-e89b-12d3-a456-426614174000',
    channel: 'email',
    subject: 'Test Email Notification',
    status: 'sent',
    ...
  }
]

✅ Tests completed! 