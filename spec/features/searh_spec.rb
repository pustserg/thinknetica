require 'feature_helper'

feature 'questions search', %q{
  In order to find interest questions
  As an guest
  I want to be able to find any questions by keywords
} do

  given(:user) { create(:user) }
  given!(:right_question) { create(:question, 
                            user: user, 
                            title: 'Right question',
                            body: 'search catch phrase') }
  given!(:wrong_question) { create(:question, title: "Wrong question" ) }

  scenario 'user tries to find question' do
    visit questions_path
    fill_in 'search', with: 'search catch phrase'
    click_on 'Find'
    save_and_open_page
    expect(page).to have_content 'Right question'
    expect(page).to_not have_content 'Wrong question'
  end

end