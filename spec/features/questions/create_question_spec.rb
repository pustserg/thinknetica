# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'Create question', %q{
  In order to get an answer from community
  As an authenticated user
  I want to be able to ask a question
} do
  
  given(:user) { create(:user) }

  scenario 'authenticated user tries to create question' do

    sign_in(user)

    visit root_path
    click_on 'Ask question'
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'text of test question'
    click_on 'Create question'

    expect(page).to have_content 'text of test question'

  end

  scenario 'Non-autheticated user tries to create question' do

    visit root_path
    click_on 'Ask question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing.'

  end

end
