require 'rails_helper'

feature 'make an answer the best', %q{
  In order to show the best answer
  As an author of question
  I want be able to marke an answer as the best
} do 

  given(:jack) { create(:user) }
  given(:dave) { create(:user) }
  given(:dave_question) { create(:question, user: dave) }
  given(:jack_answer) { create(:answer, user: jack, question: dave_question) }

  scenario 'question author tries to mark the answer as the best' do
    sign_in(dave)
    visit question_path(jack_answer.question)
    # save_and_open_page
    click_on 'Mark as best'

    expect(current_path).to eq question_path(jack_answer.question)
    expect(page).to have_content 'best answer'
  end

  scenario 'user (not a question author) tries to mark the answer as the best' do
    sign_in jack
    visit question_path(jack_answer.question)

    expect(page).to_not have_content 'Mark as best'
  end

  scenario 'guest tries to mark the answer as the best' do
    visit question_path(jack_answer.question)

    expect(page).to_not have_content 'Mark as best'
  end
  
end