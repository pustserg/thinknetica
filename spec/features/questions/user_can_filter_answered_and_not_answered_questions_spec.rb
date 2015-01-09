require 'feature_helper'

feature 'user can filter answered and not answered questions' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, title: 'Answered', answered: true) }
  given!(:another_question) { create(:question, title: 'Not answered') }
  given(:answer) { create(:answer, question: question) }

  scenario 'user tries to see answered questions' do
    visit questions_path
    within('.sidebar') do
      click_on 'Answered questions'
    end

    within('.questions') do
      expect(page).to have_content 'Answered'
      expect(page).to_not have_content 'Not answered'
    end
  end

  scenario 'user tries to see not answered questions' do
    visit questions_path
    within('.sidebar') do
      click_on 'Not answered questions'
    end

    within('.questions') do
      expect(page).to_not have_content 'Answered'
      expect(page).to have_content 'Not answered'
    end
  end

end