module ProviderSteps
  step 'I sign in with :provider' do | provider, state |
    send 'I go to the sign-in page'
    expect(find("a.#{provider.downcase}")).to_not be_nil
    click_link "Sign In With #{provider.capitalize}"
  end

  step 'I sign up with :provider' do | provider |
    send 'I go to the sign-up page'
    expect(find("a.#{provider.downcase}")).to_not be_nil
    click_link "Sign Up With #{provider.capitalize}"
  end

  step 'A new user should be created from data from :provider' do | provider |
    pending "Handle logic for determing existence from #{provider} data."
  end
end

RSpec.configure { |c| c.include ProviderSteps }
