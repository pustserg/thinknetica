require 'feature_helper'

feature 'User can filter questions by tag' do

  given(:user) { create(:user) }
  given!(:first_question) { create(:question, user: user, tag_list: "first", title: "First question") }
  given!(:second_question) { create(:question, user: user, tag_list: "second", title: "Second question") }

  scenario 'tag cloud in a sidibar' do
    visit root_path
    within('.sidebar') do
      click_on 'first'
    end
    
    expect(page).to have_content 'First question'
    expect(page).to_not have_content 'Second question'
  end

end