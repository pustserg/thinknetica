require 'feature_helper'

feature 'User can edit his comment' do 

  given(:dave) { create(:user) }
  given(:jack) { create(:user) }
  given(:question) { create(:question, user: jack) }
  # given(:answer) { create(:answer, user: jack, question: question) }
  given!(:question_comment) { create(:question_comment, commentable: question, user: jack) }
  # given!(:answer_comment) { create(:answer_comment, commentable: answer, user: jack) }

  scenario 'guest tries to edit comment', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Edit comment'
  end

  scenario 'user tries to edit comment another user', js: true do
    sign_in dave
    visit question_path(question)

    expect(page).to_not have_content 'Edit comment'
  end

  scenario 'user tries to edit comment for question', js: true do
    sign_in jack
    visit question_path(question)

    within('.question-comments') do
      click_on 'Edit comment'
    end
    fill_in 'Your comment', with: 'edited comment'

    expect(page).to have_content 'edited comment'
  end


  # scenario 'user tries to edit comment for answer' do 
  #   sign_in jack
  #   visit question_path(answer.question)
  #   save_and_open_page
  #   within('.answers') do
  #     click_on 'Edit comment'
  #   end
  #   fill_in 'Your comment', with: 'edited comment'

  #   expect(page).to have_content 'edited comment'
  # end
  
end