require 'rails_helper'

feature 'Create answer', %q{
  In order to help other user
  As an authenticated user
  I want to be able to create answer for question
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'authenticated user tries to create answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Add answer'
    # save_and_open_page
    fill_in 'Body', with: 'body of test answer'
    click_on 'Save answer'

    expect(page).to have_content 'body of test answer'
  end

  scenario 'non-authenticated user tries to create answer' do
    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'

  end

end