# frozen_string_literal: true

require 'rails_helper'
require 'rake'

describe 'rake update' do

  before do
    load File.expand_path('../../../lib/tasks/update.rake', __FILE__)
    Rake::Task.define_task(:environment)
  end

  it 'does not have an update' do
    # Nothing happens but we want to hit the file for coverage.
    Rake::Task['update'].invoke
  end
end
