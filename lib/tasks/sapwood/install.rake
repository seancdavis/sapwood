require 'fileutils'
require 'highline'

namespace :sapwood do

  desc 'Install Sapwood to a production environment'
  task :install do

    # ---------------------------------------- Setup

    root = Rails.root.to_s

    cli = HighLine.new

    cli.say "\nHi there! Welcome to the <%= color('Sapwood CLI Installation Wizard', BOLD, GREEN) %>."
    cli.say "\n----------------------------------------\n\n"
    cli.say "This wizard will do all the heavy lifting, so you don't have to"
    cli.say "worry about all this installation nonsense. There will be"
    cli.say "another installation wizard when you begin running the app, but"
    cli.say "we need to do all this first."
    cli.say "\nYou'll have to answer just a few questions so we know where to"
    cli.say "put some important values."
    cli.say "\nAnd one last thing. When you see the prompt for \"Password\","
    cli.say "we want the sudo password for the sapwood user."
    cli.say "\nOK, that's enough! Let's go!"
    cli.say "\n----------------------------------------\n\n"

    q  = "What is the FQDN (fully-qualified domain name) on which you're going "
    q += "to run Sapwood? (e.g. example.com) "
    fqdn = cli.ask(q)

    q  = "What shall we call your PostgreSQL database? "
    q += "(default: sapwood_production) "
    db_name = cli.ask(q)
    db_username = cli.ask("What about the PostgreSQL user? (default: sapwood) ")

    exit

    # ---------------------------------------- Database

    cli.say "\n----------------------------------------\n\n"
    cli.say "Setting up your PostgreSQL database ..."

    db_name = 'sapwood_production' if db_name.blank?
    db_username = 'sapwood' if db_username.blank?
    db_password = SecureRandom.hex(24)

    config = File.read("#{root}/config/database.sample.yml")
    config.gsub!(/\[db_name\]/, db_name)
    config.gsub!(/\[db_username\]/, db_username)
    config.gsub!(/\[db_password\]/, db_password)
    File.open("#{root}/config/database.yml", 'w+') { |f| f.write(config) }

    system("sudo -u postgres psql -c \"DROP DATABASE IF EXISTS #{db_name};\"")
    system("sudo -u postgres psql -c \"DROP ROLE IF EXISTS #{db_username};\"")
    system("sudo -u postgres psql -c \"CREATE ROLE #{db_username} LOGIN CREATEDB PASSWORD '#{db_password}';\"")
    system("sudo -u postgres psql -c \"CREATE DATABASE #{db_name} OWNER #{db_username};\"")

    system("RAILS_ENV=production bundle exec rake db:create")
    system("RAILS_ENV=production bundle exec rake db:schema:load")

    cli.say "\nAll done with the database."

    # ---------------------------------------- Server

    cli.say "\n----------------------------------------\n\n"
    cli.say "Setting up your Nginx and Unicorn configuration ..."

    system("sudo cp #{root}/lib/deploy/unicorn_init /etc/init.d/unicorn_sapwood")
    FileUtils.cp("#{root}/lib/deploy/unicorn.rb", "#{root}/config/unicorn.rb")
    system("sudo update-rc.d -f unicorn_sapwood defaults")

    FileUtils.mkdir_p("#{root}/tmp/pids")
    system("sudo service unicorn_sapwood start")

    nginx_config = File.read("#{root}/lib/deploy/nginx")
    nginx_config.gsub!(/\[fqdn\]/, fqdn)
    File.open("#{root}/tmp/nginx", 'w+') { |f| f.write(nginx_config) }
    system("sudo cp #{root}/tmp/nginx /etc/nginx/sites-enabled/sapwood")
    system("sudo rm /etc/nginx/sites-enabled/default")
    system("sudo service nginx restart")

    cli.say "\nAll done with the server config."

    # ---------------------------------------- Gems

    cli.say "\n----------------------------------------\n\n"
    cli.say "Installing gems ..."

    system("bundle install --without development test")

    cli.say "\nGood. Got all the gems we need."

    # ---------------------------------------- Assets

    cli.say "\n----------------------------------------\n\n"
    cli.say "Precompiling assets ..."

    system("RAILS_ENV=production bundle exec rake assets:precompile")

    cli.say "\nAnd we have all the assets."

    # ---------------------------------------- Finish Up

    cli.say "\n----------------------------------------\n\n"
    cli.say "That's it!! If everything went according to plan, and you've"
    cli.say "followed directions, then we're all set!"
    cli.say "\nVisit #{fqdn} and you can move on to the UI version of"
    cli.say "the installation."

  end

end
