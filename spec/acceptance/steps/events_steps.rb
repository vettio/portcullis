module EventSteps
  step 'I go to the new events page' do
    visit new_event_path
    expect(find("form.edit_event")).to_not be_nil
  end

  step 'it updates the internal start timestamp' do
    expect(find("form.edit_event")).to_not be_nil
    #find('#start_day').fill_in with: 'January 8th, 2016'
    #find('#start_time').fill_in with: '4:00 pm'
  end

  step 'it updates the internal end timestamp' do
  end

  step 'I set a end time & date for the event' do
  end
  step 'I set a start time & date for the event' do
  end

  step 'I have should :number tickets' do | count |
    expect(assign(:event).tickets.count).to eq(count)
  end
end

RSpec.configure { |config| config.include EventSteps }
