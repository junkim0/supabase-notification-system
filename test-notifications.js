require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

// Initialize Supabase client
const supabase = createClient(
  'http://127.0.0.1:54321',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU'  // Service role key
);

// Test users (from our seed.sql)
const USERS = {
  JOHN: 'd0fc7e7c-6d7c-4e1a-a103-9e9c4ed12345',
  JANE: 'b6e3b5a4-5c2d-4e1f-8b9a-9e9c4ed67890',
  BOB: 'a1b2c3d4-5e6f-4e5f-8e9f-9e9c4ed11111'
};

// Helper function to wait
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

// Function to send a notification
async function sendNotification(recipientId, channel, subject, content, priority = 'normal') {
  const { data, error } = await supabase.rpc('send_notification', {
    p_recipient_id: recipientId,
    p_channel: channel,
    p_subject: subject,
    p_content: content,
    p_priority: priority
  });

  if (error) {
    console.error('Error sending notification:', error);
    return null;
  }

  return data;
}

// Function to check notification status
async function checkNotificationStatus(notificationId) {
  const { data, error } = await supabase
    .from('notification_queue')
    .select(`
      id,
      channel,
      subject,
      status,
      priority,
      notification_history (
        status,
        error_message,
        processed_at
      )
    `)
    .eq('id', notificationId)
    .single();

  if (error) {
    console.error('Error checking notification:', error);
    return null;
  }

  return data;
}

// Function to list user's notifications
async function listUserNotifications(userId) {
  const { data, error } = await supabase
    .from('notification_queue')
    .select(`
      id,
      channel,
      subject,
      content,
      status,
      priority,
      created_at,
      processed_at
    `)
    .eq('recipient_id', userId)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Error listing notifications:', error);
    return [];
  }

  return data;
}

// Main test function
async function runTests() {
  console.log('🚀 Starting notification system tests...\n');

  // Test 1: Send notifications through different channels
  console.log('Test 1: Sending notifications through different channels...');
  
  // Email notification
  const emailNotifId = await sendNotification(
    USERS.JOHN,
    'email',
    'Test Email Notification',
    'This is a test email notification.',
    'high'
  );
  console.log('Email notification sent:', emailNotifId);

  // SMS notification
  const smsNotifId = await sendNotification(
    USERS.JANE,
    'sms',
    'Test SMS Alert',
    'This is a test SMS notification.',
    'normal'
  );
  console.log('SMS notification sent:', smsNotifId);

  // In-app notification
  const inAppNotifId = await sendNotification(
    USERS.BOB,
    'in_app',
    'Test In-App Message',
    'This is a test in-app notification.',
    'low'
  );
  console.log('In-app notification sent:', inAppNotifId);

  // Wait for processing
  console.log('\nWaiting for notifications to be processed...');
  await sleep(1000);

  // Test 2: Check notification statuses
  console.log('\nTest 2: Checking notification statuses...');
  
  const emailStatus = await checkNotificationStatus(emailNotifId);
  console.log('Email notification status:', emailStatus?.status);
  
  const smsStatus = await checkNotificationStatus(smsNotifId);
  console.log('SMS notification status:', smsStatus?.status);
  
  const inAppStatus = await checkNotificationStatus(inAppNotifId);
  console.log('In-app notification status:', inAppStatus?.status);

  // Test 3: List user's notifications
  console.log('\nTest 3: Listing notifications for John...');
  const johnsNotifications = await listUserNotifications(USERS.JOHN);
  console.log('John\'s notifications:', johnsNotifications);

  console.log('\n✅ Tests completed!');
}

// Run the tests
runTests().catch(console.error); 