require 'feature_helper'

feature 'User adds a tags to a question when creates a question' do

  given(:user) { create(:user) }
  scenario 'User creates a question with tags' do
    sign_in user
    visit new_question_path
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'text of test question'
    fill_in 'Tags', with: 'test, tag'
    click_on 'Create question'

    expect(page).to have_link 'test'
    expect(page).to have_link 'tag'
  end
 
end