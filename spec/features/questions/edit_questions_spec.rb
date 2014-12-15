require 'rails_helper'

feature 'edit question', %q{
  In order to improve my question
  As an author of question
  I want to be able to edit my question
} do 

  given(:jack) { create(:user) }
  given(:dave) { create(:user) }

  given(:question) { dave.questions.create(attributes_for(:question)) }

  scenario 'authenticated user tries to edit his question' do
    
    sign_in(dave)
    visit question_path(question)

    click_on 'Edit question'

    fill_in 'Title', with: 'New title'
    fill_in 'Body', with: 'New body'
    click_on 'Update question'

    expect(page).to have_content 'New title'
    expect(page).to have_content 'New body'
    expect(current_path).to eq question_path(question)

  end

  scenario 'authenticated user tries to edit question of another user' do
    
    sign_in(jack)
    visit question_path(question)

    expect(page).to_not have_content 'Edit question'

  end
  
  scenario 'non-authenticated user tries to edit question' do
    
    visit question_path(question)

    expect(page).to_not have_content 'Edit question'

  end

end