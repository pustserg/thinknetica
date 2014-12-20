require 'feature_helper'

feature 'User sign up', %q{
  In order to be able to ask question
  As a guest
  I want to be able to sign up
} do

  scenario 'Guest tries to sign up' do
    visit '/signup'
    fill_in 'Email', with: "useremail@think.test"
    fill_in 'Password', with: "testpassword"
    fill_in 'Password confirmation', with: "testpassword"
    click_on 'Sign up'


    expect(page).to have_content("Welcome! You have signed up successfully.")
    expect(current_path).to eq root_path
  end
  
end