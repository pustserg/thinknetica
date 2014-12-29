require 'feature_helper'

feature 'User adds tags when creates a question' do
    
  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds file when creates a question' do
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'
    fill_in 'Tags', with: 'question, tag'
    click_on 'Create'

    expect(page).to have_link 'question'
    expect(page).to have_link 'tag'

  end

end