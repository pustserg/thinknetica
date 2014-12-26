# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'User adds vote for comment', %q{
  In order to support comment
  As an authenticated user
  I want to able to vote pro or contra for a another user comment
} do 

  given(:dave) { create(:user) }
  given(:jack) { create(:user) }

  given(:question) { create(:question, user: jack) }
  given!(:comment) { create(:question_comment, user: jack, commentable: question) }

  scenario 'guest tries to vote for answer' do
    visit question_path(question)
    # save_and_open_page
    within('.question-comments') do
      expect(page).to_not have_link "+"
      expect(page).to_not have_link "-"
    end
  end

  scenario 'user tries to vote for his question' do
    sign_in jack
    visit question_path(question)
    
    within('.question-comments') do
      expect(page).to_not have_link "+"
      expect(page).to_not have_link "-"
    end
  end

  scenario 'user tries to vote for another user question', js: true do
    sign_in dave
    visit question_path(question)

    within('.question-comments') do
      click_on "+"
      click_on "-"
       
      expect(page).to have_content 'Likes: 1'
      expect(page).to have_content 'Dislikes: 1'
    end
  end
  
end
