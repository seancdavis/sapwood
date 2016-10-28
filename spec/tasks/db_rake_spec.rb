require 'rails_helper'

describe "Database Backups" do

  it 'will create a backup and clean up excess files' do
    Rails.application.load_tasks

    backup_dir = Rails.root.join('db', 'backups')
    file_pattern = "#{backup_dir}/*.psql"

    # Remove any lingering files.
    Dir.glob(file_pattern).each { |f| FileUtils.rm(f) }

    # Check that the directory is empty.
    expect(Dir.glob(file_pattern).size).to eq(0)

    15.times { |idx| FileUtils.touch("#{backup_dir}/test_#{idx + 1}.psql") }
    expect(Dir.glob(file_pattern).size).to eq(15)

    Rake::Task['db:backup'].invoke

    # Check that there are only 10 backups in the directory.
    expect(Dir.glob(file_pattern).size).to eq(10)

    # And check that one of them is the newly created file.
    db_name = Rails.configuration.database_configuration[Rails.env]["database"]
    expected_filename = "#{db_name}_#{Time.now.strftime("%y%m%d")}.psql"
    backup_filenames = Dir.glob(file_pattern).collect { |f| f.split('/').last }
    expect(backup_filenames).to include(expected_filename)
  end

end
