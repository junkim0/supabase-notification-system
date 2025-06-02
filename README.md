# Supabase Notification System

A robust notification system built with Supabase, demonstrating real-time message processing and multi-channel delivery capabilities.

## Features

- **Multi-Channel Notifications**: Support for email, SMS, and in-app notifications
- **Priority Levels**: Handle messages with different priority levels (low, normal, high)
- **Queue Management**: Efficient message queuing and processing
- **Status Tracking**: Real-time tracking of notification status
- **Success Rate Simulation**: Simulated success rates for different channels
  - In-app: 100% success rate
  - Email: 90% success rate
  - SMS: 80% success rate

## Tech Stack

- **Backend**: Supabase (PostgreSQL)
- **Database**: PostgreSQL with Row Level Security
- **Testing**: Node.js test suite
- **Authentication**: Supabase Auth

## Local Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/junkim0/supabase-notification-system.git
   cd supabase-notification-system
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start Supabase locally:
   ```bash
   npx supabase start
   ```

4. Run the tests:
   ```bash
   npm test
   ```

## Database Schema

The system uses the following main tables:

### Core Tables
- `users`: User information and preferences
- `teams`: Team organization
- `posts`: Content that can trigger notifications

### Notification Tables
- `notification_queue`: Active notifications being processed
- `notification_history`: Record of processed notifications

## Testing

The test suite (`test-notifications.js`) demonstrates:
- Sending notifications through different channels
- Checking notification status
- Listing user notifications
- Priority handling
- Status tracking

Test results are stored in the `test-results` directory.

## Security

- Row Level Security (RLS) policies for data access control
- Service role key available for testing purposes
- Anonymous access restricted by default

## Development Notes

1. **Local Environment**:
   - API URL: http://127.0.0.1:54321
   - Database: postgresql://postgres:postgres@127.0.0.1:54322/postgres
   - Studio: http://127.0.0.1:54323

2. **Authentication**:
   - Development uses service role key for testing
   - Production should implement proper user authentication

## Next Steps

1. Production Authentication:
   - Implement user authentication
   - Configure RLS policies
   - Move away from service role key

2. Additional Testing:
   - Add error case testing
   - Implement rate limiting
   - Add load testing

3. Monitoring:
   - Queue length tracking
   - Channel success rates
   - Processing time metrics

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.