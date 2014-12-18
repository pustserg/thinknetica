require 'rails_helper'

feature 'Create answer', %q{
  In order to help other users
  As an authenticated user
  I want to be able to create answer for question
} do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'authenticated user tries to create answer', js: true do
    sign_in(user)
    visit question_path(question)
    
    fill_in 'Your answer', with: 'body of test answer'
    click_on 'Save answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'body of test answer'
    end
  end

  scenario 'non-authenticated user tries to create answer' do
    visit question_path(question)

    fill_in 'Your answer', with: 'body of test answer'
    click_on 'Save answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'

  end

end