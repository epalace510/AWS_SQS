#!/usr/bin/env ruby
require 'rubygems'
require 'aws-sdk'

AWS.config(
  :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
)
@sqs=AWS::SQS.new
puts 'Creating queues'
test1=@sqs.queues.create("csc470test")
test2=@sqs.queues.create("csc470test2")
puts 'Queues created'
gets
puts 'Fetching data for "csc470test"'
puts "Creation time: #{test1.created_timestamp}"
puts "ARN: #{test1.arn}"
puts "Message Retention Period: #{test1.message_retention_period} seconds"
puts "Queue last modified at: #{test1.last_modified_timestamp}"
puts
gets
puts 'All queues associated with this account:'
puts @sqs.queues.map(&:url)
puts
gets
puts 'Sending three messages to csc470test'
puts 'Sending "test1"'
test1.send_message('test1')
puts 'Message 1 sent.'
gets
puts 'Sending "test2"'
test1.send_message('test2')
puts 'Message 2 sent'
gets
puts 'Sending "test3"'
test1.send_message('test3')
puts 'Message 3 sent'
gets
puts 'Deleting csc470test2 queue'
test2.delete
sleep 1 while test2.exists?
puts 'Queue deleted.'
gets

puts 'Printing approximate number of messages in csc470test queue'
puts "There are approximately #{test1.approximate_number_of_messages} messages."
gets
puts 'Receiving and printing first message from queue.'
message = test1.receive_message(:limit => 1)
puts "The body of the message is #{message.body}"
gets
puts 'Retrieving next two messages from queue.'
2.times do
  message = test1.receive_message(:limit => 1)
  puts "The body of the message is #{message.body}"
end
puts 'All three messages have been received.'
gets
puts 'Deleting csc470test queue'
test1.delete
sleep 1 while test1.exists?
puts 'Queue deleted.'
