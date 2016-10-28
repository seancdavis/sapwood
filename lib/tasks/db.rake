namespace :db do

  desc "Dumps the database to db/backups"
  task :backup => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      date = Time.now.strftime("%y%m%d")
      db_file = "#{backup_dir}/#{db}_#{date}.psql"
      system "pg_dump -F c -h #{host} --clean --no-owner -d #{db} -f #{db_file}"
    end
    Rake::Task["db:purge_backups"].invoke
  end

  desc "Remove old backup files"
  task :purge_backups => :environment do
    backups = Dir.glob("#{backup_dir}/*.psql").sort
    (backups - backups.first(10)).each { |backup| FileUtils.rm(backup) }
  end

  desc "Restores the database from backups"
  task :restore, [:date] => :environment do |task,args|
    raise 'Please pass a date to the task' unless args.date.present?
    cmd = nil
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    with_config do |app, host, db, user|
      db_file = "#{Rails.root}/db/backups/#{db}_#{args.date}.psql"
      system "pg_restore -F c -d #{db} #{db_file}"
    end
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
          ActiveRecord::Base.connection_config[:host] || 'localhost',
          ActiveRecord::Base.connection_config[:database],
          ActiveRecord::Base.connection_config[:username]
  end

  def backup_dir
    @backup_dir ||= begin
      dir = Rails.root.join('db', 'backups')
      FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
      dir
    end
  end

end
