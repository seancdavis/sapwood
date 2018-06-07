require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do

  describe '#welcome' do
    before(:each) do
      # remove_config
      @property = property_with_templates
      @element = create(:element, :with_options, :property => @property)
      @user = create(:admin)
      @notification = create(:notification, :user => @user,
                             :property => @property)

      @element[:template_data]['complete'] = '1'
      # Create elements that we can use for associated records.
      more_options_el = create(:element, :property => @property,
                               :template_name => 'More Options')
      @one_thing_el = create(:element, :property => @property,
                            :template_name => 'One Thing')
      @many_things_els = create_list(:element, 3, :property => @property,
                                    :template_name => 'Many Things')
      # Add the implicit has_many
      more_options_el[:template_data]['option'] = @element.id.to_s
      more_options_el.save!
      # Add the belongs_to.
      @element[:template_data]['one_thing'] = @one_thing_el.id.to_s
      # Add the has_many, including one that doesn't belong.
      bad_element = create(:element)
      @element[:template_data]['many_things'] = (@many_things_els + [bad_element])
        .collect(&:id).join(',')
      # Adding has_many documents
      @documents = [create(:element, :document, :property => @property),
                   create(:element, :document, :property => @property)]
      @element[:template_data]['images'] = @documents.collect(&:id).join(',')
      # And our mixed bags.
      @mixed_bag_el = create(:element, :property => @property,
                            :template_name => 'One Thing')
      @element[:template_data]['mixed_bag'] = @mixed_bag_el.id.to_s
      @mixed_bag_els = [
        create(:element, :document, :property => @property),
        create(:element, :property => @property, :template_name => 'One Thing')
      ]
      @element[:template_data]['mixed_bags'] =
        @mixed_bag_els.collect(&:id).join(',')
      # Save our element.
      @element.save!

      @mail = NotificationMailer.notify(
        :element => @element,
        :notification => @notification,
        :action_name => 'create',
        :template => @property.find_template(@element.template_name),
        :property => @property
      )
    end
    it 'sends from the settings default' do
      email = Sapwood.config.default_from.split('<')[-1][0..-2]
      expect(@mail.from).to eq([email])
    end
    it 'sends to the user' do
      expect(@mail.to).to eq([@user.email])
    end
    it 'displays the appropriate data for the element' do
      expect(@mail.body.encoded).to include(@element.id.to_s)
      expect(@mail.body.encoded).to include(@element.title)
      expect(@mail.body.encoded).to include(@element.slug)
      expect(@mail.body.encoded).to include(@element.created_at.to_s)
      expect(@mail.body.encoded).to include(@element.updated_at.to_s)
      expect(@mail.body.encoded).to include(@element.title)
      expect(@mail.body.encoded).to include(@element.image.title)
      @documents.each do |img|
        expect(@mail.body.encoded).to include(img.title)
      end
      expect(@mail.body.encoded).to include(@one_thing_el.title)
      @many_things_els.each do |el|
        expect(@mail.body.encoded).to include(el.title)
      end
      expect(@mail.body.encoded).to include(@mixed_bag_el.title)
      @mixed_bag_els.each do |el|
        expect(@mail.body.encoded).to include(el.title)
      end
    end

    # Note: Subjects are tested in features/notifications/send_notification_spec
  end

end
