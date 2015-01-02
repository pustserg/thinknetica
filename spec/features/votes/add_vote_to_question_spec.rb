# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'User adds vote for question', %q{
  In order to support question
  As an authenticated user
  I want to able to vote pro or contra for a another user question
} do

  given(:dave) { create(:user) }
  given(:jack) { create(:user) }
  given(:question) { create(:question, user: jack) }

  scenario 'guest tries to vote for question' do
    visit question_path(question)

    within('.question') do
      expect(page).to_not have_link "+"
      expect(page).to_not have_link "-"
    end
  end

  scenario 'user tries to vote for his question' do
    sign_in jack
    visit question_path(question)

    within('.question') do
      expect(page).to_not have_link "+"
      expect(page).to_not have_link "-"
    end
  end

  scenario 'user tries to like for another user question', js: true do
    sign_in dave
    visit question_path(question)

    within('.question') do
      click_on "+"
      click_on "+"

      expect(page).to have_content 'Likes: 1'

    end
  end

  scenario 'user tries to dislike for another user question', js: true do
    sign_in dave
    visit question_path(question)

    within('.question') do
      click_on "-"
      click_on "-"

      expect(page).to have_content 'Dislikes: 1'

    end
  end

end

