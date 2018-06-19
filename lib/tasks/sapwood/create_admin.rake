# frozen_string_literal: true

namespace :sapwood do

  desc 'Create a random administrator user'
  task create_admin: :environment do

    email = "admin@#{ENV['FQDN']}"
    password = SecureRandom.hex(10)

    User.create!(email: email, password: password, is_admin: true)

    puts 'Your admin user is:'
    puts "\n    email: #{email}"
    puts "    password: #{password}"
  end
end
