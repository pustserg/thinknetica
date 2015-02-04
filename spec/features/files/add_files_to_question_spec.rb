# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question author
  I want to be able to attach files
} do
  
  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds file when creates a question' do
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: "/uploads/attachment/file/#{Attachment.first.id}/spec_helper.rb"
  end
end
