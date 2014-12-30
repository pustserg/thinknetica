require 'feature_helper'

feature 'tag cloud is shown on sidebar' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user, tag_list: 'first, last') }

  scenario 'Guest can see tag cloud on sidebar' do
    visit questions_path
    within('.sidebar') do
      expect(page).to have_link 'first'
      expect(page).to have_link 'last'
    end
  end

end