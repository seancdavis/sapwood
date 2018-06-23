module FeatureHelpers

  def sign_in(user, password = 'password')
    visit root_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: password
    click_button 'Sign In'
  end

  def sign_out
    page.find('#sign-out').click
  end

  def upload_file(filename)
    page.execute_script("$('#fileupload').toggle();")
    attach_file 'file', ["#{Rails.root}/spec/support/#{filename}"]
    wait_for_ajax
  end

  def upload_image
    upload_file('example.png')
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

end
