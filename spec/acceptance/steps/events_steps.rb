module EventSteps
  step 'I start making a new event' do
    expect(@current_user).to_not be_nil
    send 'I go to create an event'
    ['Location', 'Content', 'Timing', 'Classification', 'Tickets'].each do | region |
      expect(page).to have_content region 
    end
  end

  step 'I go to the edit events page' do
    visit edit_event_path(@event)
    expect(find('form.edit_event')).to_not be_nil
  end

  step "there shouldn't be any HTML code on the event page" do
    description = first 'section#description'
  end

  step "I set the event's title with :title" do | title |
    fill_in 'event[name]', with: title
    expect(find('#event_name').value).to eq title
  end

  step "I fill in the event's content" do
    step "I set the event's title to be \"#{Faker::Lorem.sentence}\""
    step "I set the event's description to some placeholder text"
  end

  step 'I set the event\'s description to some placeholder text' do
    awesome_description_text = Faker::Lorem.paragraphs.join("\n")
  end

  step 'I populate the time range for the event' do
    date_start = Time.now + Random.rand(20).to_i.days
    date_end = date_start + Random.rand(15).to_i.hours
    page.evaluate_script("alert($('#start_day'))")
  end

  step 'I have should :number tickets for the event' do | count |
    expect(assign(:event).tickets.count).to eq(count)
  end

  step 'I have a pre-existing event' do
    @event = create :event, :with_tickets
  end

  step 'the pre-existing event is currently active' do
    @event.date_start = Time.zone.now + 2.days
    @event.date_end = @event.date_start + 2.days
    @event.save!
  end

  step 'it should create a new event' do
    expect(page).to have_content 'successfully updated'
  end

  step 'I confirm creation of the event' do
    within 'form.edit_event' do
      click_on 'Save Event'
    end
  end

  step 'It should show the new event page' do
    expect(page).to have_content 'New Event'
  end

  step 'there should be an unlisted event named :name' do | name |
    expect(page).to have_content 'event is unlisted'
  end

  step "there is a password-protected event I don't own" do
    @event = create :event, :protected
    expect(Ability.new(@current_user).can?(:modify, @event)).to be_false
  end

  step "there is an unlisted event I don't own" do
    @event = create :event, :unlisted
    expect(Ability.new(@current_user).can?(:modify, @event)).to be_false
  end

  step 'I enter the password for the password-protected event' do
    fill_in 'event[password]', with: @event.password
    click_on 'Submit Password'
  end

  step 'I should be able to view the event' do
    expect(page).to have_content @event.description
    expect(page).to have_content @event.name
  end

  step 'I should be able to view the password-protected event' do
    send 'I should be able to view the event'
    #expect(page).to have_content 'protected event'
  end

  step 'I should be required to enter a password to view the event' do
    step 'I should see the text "Password" on the page'
  end

  step 'I enter the password for the password-protected event' do
    fill_in 'Password', with: @event.password
    click_on 'Enter Event'
  end

  step 'I should be redirected to the event' do
    expect(current_path).to eq(event_path(@event))
  end
end

RSpec.configure { |config| config.include EventSteps }
