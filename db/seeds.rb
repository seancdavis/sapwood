# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

password = SecureRandom.hex(4)
User.create!(:email => 'admin@example.com', :password => password,
             :is_admin => true)

msg  = "\nYour admin credentials are:\n\n  email: admin@example.com"
msg += "\n  password: #{password}\n\nYou will be asked to change these after "
msg += "you first login."
puts msg
