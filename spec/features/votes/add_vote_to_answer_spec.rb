# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'User adds vote for answer', %q{
  In order to support answer
  As an authenticated user
  I want to able to vote pro or contra for a another user answer
} do 

  given(:dave) { create(:user) }
  given(:jack) { create(:user) }

  given(:question) { create(:question, user: jack) }
  given(:answer) { create(:answer, user: jack, question: question) }

  scenario 'guest tries to vote for answer' do
    visit question_path(answer.question)
    
    within('.votes') do
      expect(page).to_not have_link "+"
      expect(page).to_not have_link "-"
    end
  end

  scenario 'user tries to vote for his question' do
    sign_in jack
    visit question_path(answer.question)
    
    within('.votes') do
      expect(page).to_not have_link "+"
      expect(page).to_not have_link "-"
    end
  end

  scenario 'user tries to like another user question', js: true do
    sign_in dave
    visit question_path(answer.question)

    within('.votes') do
      click_on "+"
      click_on "+"
    end

    within('.answer-likes') do
      expect(page).to have_content 'Likes: 1'
    end
  end

  scenario 'user tries to dislike for another user question', js: true do
    sign_in dave
    visit question_path(answer.question)

    within('.votes') do
      click_on "-"
      click_on "-"
    end

    within('.answer-likes') do
      expect(page).to have_content 'Dislikes: 1'
    end
  end
  
end
