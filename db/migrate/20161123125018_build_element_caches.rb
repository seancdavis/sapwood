# frozen_string_literal: true

class BuildElementCaches < ActiveRecord::Migration
  def up
    Element.all.each { |el| el.delay.as_json }
  end
end
