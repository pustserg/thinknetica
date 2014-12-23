require 'feature_helper'

feature 'User can create comment to a question', %q{
  In order to explain a question
  As an user 
  I want be able to comment a question
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, user: user, question: question) }

  describe 'comment for question' do
    scenario 'Authenticated user tries to create a comment for question', js: true do
      sign_in user
      visit question_path(question)

      within ('.question') do
        click_on 'Add comment'
      end  
      
      fill_in 'Your comment', with: 'test comment'
      click_on 'Save comment'
      
      expect(current_path).to eq question_path(question)
      within('.question-comments') do
        expect(page).to have_content 'test comment'
      end

    end

    scenario 'Guest tries to create a comment', js: true do
      visit question_path(question)

      expect(page).to_not have_content 'Add comment'

    end

    scenario 'User tries to create comment with empty body', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Add comment'
      
      click_on 'Save comment'

      expect(page).to have_content "Body can't be blank"

    end
  end

  describe 'comment for answer' do
    
    scenario 'Authenticated user tries to create comment for answer', js: true do
      sign_in user
      visit question_path(answer.question)
      
      within('.answers') do
        click_on 'Add comment'
      end

      fill_in 'Your comment', with: 'test comment'
      click_on 'Save comment'

      expect(current_path).to eq question_path(question)

      within('.answer-comments') do
        expect(page).to have_content 'test comment'
      end
    end
  end

  
end