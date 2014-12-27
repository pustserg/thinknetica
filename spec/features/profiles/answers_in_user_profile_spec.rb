require 'feature_helper'

feature 'User can see his answers list in profile', %q{
  In order to remember my answers
  As an authenticated user
  I want to see all my answers in profile
} do
  
  given(:dave) { create(:user) }
  given(:jack) { create(:user) }
  given(:question) { create(:question) }

  given!(:dave_answer) { create(:answer, user: dave, question: question, body: 'dave answer') }
  given!(:jack_answer) { create(:answer, user: jack, question: question, body: 'jack answer') }

  background do
    sign_in dave
    visit profile_path(dave)
  end

  scenario 'User sees all his answers in profile' do
    expect(page).to have_content dave_answer.body
  end

  scenario 'User does not see another user answers in profile' do
    expect(page).to_not have_content jack_answer.body
  end

end