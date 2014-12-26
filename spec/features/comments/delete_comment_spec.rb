# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'Author can delete his comment', %q{
  In order to delete silly comment
  As an comment author 
  I want to be able to delete comment
} do 

  given(:dave) { create(:user) }
  given(:jack) { create(:user) }
  given(:question) { create(:question) }
  given(:jack_comment) { create(:question_comment, user: jack, body: 'jack comment') }
  
  scenario 'Guest tries to delete comment' do
    visit question_path(jack_comment.commentable)
    # save_and_open_page
    expect(page).to_not have_content 'Delete comment'
  end

  scenario 'User tries to delete another user comment' do
    sign_in dave
    visit question_path(jack_comment.commentable)
    
    expect(page).to_not have_content 'Delete comment'

  end

  scenario 'User tries to delete his comment' do
    sign_in jack
    visit question_path(jack_comment.commentable)

    click_on 'Delete comment'

    expect(page).to_not have_content 'jack_comment'
  end
  
end
