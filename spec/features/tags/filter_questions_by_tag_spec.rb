require 'feature_helper'

feature 'Guest can filter question list by tag' do

  given(:user) { create(:user) }
  given!(:first_question) { create(:question, user: user, title: 'first', tag_list: 'first') }
  given!(:second_question) { create(:question, user: user, title: 'second', tag_list: 'second') }

  scenario 'when visit question index page with tag' do
    visit tag_path('first')

    within('.questions') do
      expect(page).to have_content 'first'
      expect(page).to_not have_content 'second'
    end
  end

end