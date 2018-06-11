<<<<<<< HEAD
# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  property_id   :integer
#  template_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

=======
>>>>>>> v3.0
module NotificationsHelper
  def notification_on?
    return false if current_template.blank? || current_property.blank?
    current_user.notifications.for_template(current_template)
                .in_property(current_property).present?
  end

  def notification_toggle_path(template)
    return nil if current_template.blank? || current_property.blank?
    property_notifications_path current_property,
                                template: URI.encode(template),
                                redirect_to: request.path
  end
end
