require './application'

message = Message.new sender_id: User.first.id, recipient_id: User.first.id, message: "test message"
message.save

message = Message.new sender_id: User.first.id, recipient_id: User.first.id, message: "test mes2age"
message.save

puts message
