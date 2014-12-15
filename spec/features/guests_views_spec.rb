require 'rails_helper'

feature 'Guests are able to see questions and answers', %q{
  In order to know what is the site
  As Guest
  I want to be able see questions and answers
} do
  
  given(:user) { create(:user) }
  given!(:question) { user.questions.create(attributes_for(:question)) }
  given!(:answer) { question.answers.create(attributes_for(:answer, user_id: user.id)) }

  scenario 'guests visit question_index_path' do
    visit root_path
    
    expect(page).to have_content question.body
  end

  scenario 'guest visits question_path' do
    visit question_path(answer.question)
    
    expect(page).to have_content(answer.body)
  end

end