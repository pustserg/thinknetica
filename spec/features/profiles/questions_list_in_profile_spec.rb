require 'feature_helper'

feature 'User can see his questions list in profile', %q{
  In order to remember my questions
  As an authenticated user
  I want to see all my questions in profile
} do
  
  given(:dave) { create(:user) }
  given(:jack) { create(:user) }

  given!(:dave_question) { create(:question, user: dave, title: 'dave question') }
  given!(:jack_question) { create(:question, user: jack, title: 'jack question') }

  background do
    sign_in dave
    visit profile_path(dave)
  end

  scenario 'User sees all his questions in profile' do
    expect(page).to have_content dave_question.title
  end

  scenario 'User does not see another user questions in profile' do
    expect(page).to_not have_content jack_question.title
  end

end