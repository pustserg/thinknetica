require 'rails_helper'

feature 'Guests are able to see questions and answers', %q{
  In order to know what is the site
  As Guest
  I want to be able see questions and answers
} do
  
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }

  scenario 'guests visit question_index_path' do
    visit root_path
    
    expect(page).to have_content question.body
  end

  scenario 'guest visits question_path' do
    visit question_path(answer.question)
    
    expect(page).to have_content(answer.body)
  end

end