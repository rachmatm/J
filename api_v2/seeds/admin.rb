ENV['RACK_ENV'] = 'production'
require './application'

Admin.where(:username => 'Lord').destroy_all
admin = Admin.create :username => 'jotkylord', :password => 'Johnny55'

puts "Lord of Jotky was born."
