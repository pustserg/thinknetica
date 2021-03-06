# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'User can add files to answer', %q{
  In order to illustrate my answer
  As an question author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'user adds file to answer while creates answer', js: true do
    fill_in 'Your answer', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save answer'
    # save_and_open_page
    # expect(Attachment.count).to eq 1
    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/#{Attachment.first.id}/spec_helper.rb"
    end
  end

end
