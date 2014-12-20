require 'feature_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
  } do

    given(:user) { create(:user) }

    scenario 'Registered user tries to sign in' do

      sign_in(user)

      expect(page).to have_content 'Signed in successfully.'
      expect(current_path).to eq root_path
    end

    scenario 'Non-registeres user tries to sign in' do

      visit '/login'
      fill_in 'Email', with: 'wronguser@think.test'
      fill_in 'Password', with: 'testpassword'
      click_on 'Log in'

      expect(page).to have_content 'Invalid email or password'
      expect(current_path).to eq '/login'

    end

  end