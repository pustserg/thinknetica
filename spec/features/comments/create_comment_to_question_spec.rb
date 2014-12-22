require 'feature_helper'

feature 'User can create comment to a question', %q{
  In order to explain a question
  As an user 
  I want be able to comment a question
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user tries to create a comment', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Add comment'
    
    fill_in 'comment', with: 'test comment'
    click_on 'Save comment'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'test comment'

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