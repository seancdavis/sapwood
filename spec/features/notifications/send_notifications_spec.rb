# frozen_string_literal: true

require 'rails_helper'

feature 'Notifications', js: true do

  scenario 'are sent when an element is created to enablers except me' do
    @property = property_with_templates
    @me = create(:admin)
    create(:notification, user: @me, property: @property)
    @other_user = create(:admin)
    create(:notification, user: @other_user, property: @property)
    # Create a few other notifications that shouldn't be affected.
    create(:notification, user: @other_user, template_name: 'AllOptions')
    create(:notification, user: @other_user)
    create(:notification)

    email_count = ActionMailer::Base.deliveries.count

    sign_in @me
    visit new_property_template_element_path(@property, 'default')
    title = Faker::Lorem.sentence
    fill_in 'element[template_data][name]', with: title
    click_button 'Save Default'
    expect(ActionMailer::Base.deliveries.count).to eq(email_count += 1)
    expect(ActionMailer::Base.deliveries.last.to).to eq([@other_user.email])
    subject = "A new default was created in #{@property.title}"
    expect(ActionMailer::Base.deliveries.last.subject).to eq(subject)

    click_link title
    title = Faker::Lorem.sentence
    fill_in 'element[template_data][name]', with: title
    click_button 'Save Default'
    expect(ActionMailer::Base.deliveries.count).to eq(email_count += 1)
    expect(ActionMailer::Base.deliveries.last.to).to eq([@other_user.email])
    subject = "Default #{title} updated in #{@property.title}"
    expect(ActionMailer::Base.deliveries.last.subject).to eq(subject)
  end

end
