require 'feature_helper'

feature 'User can see his comments in his profile' do

  given(:dave) { create(:user) }
  given(:jack) { create(:user) }
  given(:question) { create(:question) }

  given!(:dave_comment) { create(:comment, commentable: question, body: "dave comment") }
  given!(:jack_comment) { create(:comment, commentable: question, body: "jack comment") }

  background do
    sign_in dave
    visit profile_path(dave)
  end

  scenario 'User can see his comment in profile' do
    expect(page).to have_content("dave comment")
  end

  scenario 'User does not see another user comment in profile' do
    expect(page).to_not have_content("jack comment")
  end

end