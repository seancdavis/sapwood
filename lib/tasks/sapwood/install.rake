require 'fileutils'
require 'highline'

namespace :sapwood do

  desc 'Install Sapwood to a production environment'
  task :install do

    begin

    # ---------------------------------------- Setup

    root = Rails.root.to_s

    cli = HighLine.new

    cli.say "\nHi there! Welcome to the <%= color('Sapwood CLI Installation Wizard', BOLD, GREEN) %>."
    cli.say "\n----------------------------------------\n\n"
    cli.say "This wizard will do all the heavy lifting, so you don't have to"
    cli.say "worry about all this installation nonsense. There will be"
    cli.say "a few more things to do once the app is running, but"
    cli.say "we need to do all this first."
    cli.say "\nYou'll have to answer just a few questions so we know where to"
    cli.say "put some important values."
    cli.say "\nCool? Cool. Let's go!"
    cli.say "\n----------------------------------------\n\n"

    q  = "What is the FQDN (fully-qualified domain name) on which you're going "
    q += "to run Sapwood? (e.g. example.com) "
    fqdn = cli.ask(q)

    q  = "What shall we call your PostgreSQL database? "
    q += "(default: sapwood_production) "
    db_name = cli.ask(q)
    db_username = cli.ask("What about the PostgreSQL user? (default: sapwood) ")

    q = "\nWhat is the email address from which you'd like to send notifications? "
    default_from_email = cli.ask(q)
    q = "What name do you want to display on the email notification? "
    default_from_name = cli.ask(q)

    cli.say "\nNow let's get your SendGrid credentials ..."
    user_name = cli.ask("SendGrid Username: ")
    password = cli.ask("SendGrid Password: ") { |q| q.echo = "*" }
    domain = cli.ask("SendGrid Domain: ")
    send_grid = {
      'user_name' => user_name,
      'password' => password,
      'domain' => domain
    }

    cli.say "\nAwesomesauce! Moving on to Amazon AWS ..."
    access_key_id = cli.ask("Amazon AWS Access Key ID: ") { |q| q.echo = "*" }
    secret_access_key = cli.ask("Amazon AWS Secret Access Key: ") { |q| q.echo = "*" }
    bucket = cli.ask("Amazon S3 Bucket Name: ")
    amazon_aws = {
      'access_key_id' => access_key_id,
      'secret_access_key' => secret_access_key,
      'bucket' => bucket
    }

    # ---------------------------------------- Sapwood Config

    Sapwood.reload!

    Sapwood.set('url', "http://#{fqdn.gsub(/https?\:\/\//, '')}")
    Sapwood.set('default_from', "#{default_from_name} <#{default_from_email}>")
    Sapwood.set('send_grid', send_grid)
    Sapwood.set('amazon_aws', amazon_aws)

    Sapwood.write!

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

    system("sudo service unicorn_sapwood restart")

    cli.say "\n----------------------------------------\n\n"
    cli.say "That's it!! If everything went according to plan, and you've"
    cli.say "followed directions, then we're all set!"
    cli.say "\nVisit #{fqdn} and you can move on to the UI version of"
    cli.say "the installation.\n\n"

    # ---------------------------------------- Errors

    rescue Exception => e

      cli.say "\n----------------------------------------\n\n"

      raise e

      cli.say "\n----------------------------------------\n\n"
      cli.say "Hmmm ... something didn't work quite right. If you're having"
      cli.say "trouble, double-check the installation instructions. And if that"
      cli.say "doesn't work, log an issue at https://github.com/seancdavis/sapwood/issues/new\n\n"

    end

  end

end
