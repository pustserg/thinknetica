# -*- encoding : utf-8 -*-
module FeatureHelpers
  
  def sign_in(user)

    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    
  end

end
