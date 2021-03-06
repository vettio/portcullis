module RoutingSteps
  step 'I should be redirected to :url' do | url |
    expect(current_url).to eq(url)
  end

  step 'I go to the sign-in page' do
    visit new_user_session_path
    expect(page).to have_content 'Sign In'
  end

  step 'I go to the sign-up page' do
    visit new_user_registration_path
    expect(page).to have_content 'Sign Up'
  end

  step 'I go to the sign-out page' do
    visit destroy_user_session_path
  end

  step 'I go to the password recovery page' do
    visit new_user_password_path
  end

  step 'I go to view the event' do
    visit event_path(@event)
  end

  step 'I go to create an event' do
    visit new_event_path
  end

  step 'I go to the new events page' do
    send 'I go to create an event'
  end

  step 'I go to the search page' do
    visit search_path
  end
end

RSpec.configure { |c| c.include RoutingSteps  }
