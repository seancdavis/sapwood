require 'rails_helper'
require 'rake'

describe 'rake sapwood:create_admin' do

  before do
    load File.expand_path("../../../lib/tasks/sapwood/create_admin.rake", __FILE__)
    Rake::Task.define_task(:environment)
  end

  it 'Creates an administrative user' do
    expect(User.count).to eq(0)
    Rake::Task["sapwood:create_admin"].invoke
    expect(User.count).to eq(1)
    admin = User.first
    expect(admin.is_admin?).to eq(true)
    expect(admin.email).to eq('admin@localhost.dev')
  end
end
