# frozen_string_literal: true

module ApplicationHelper

  def can_view_deck?
    return true if current_user.is_admin?
    my_properties.size > 1
  end

end
