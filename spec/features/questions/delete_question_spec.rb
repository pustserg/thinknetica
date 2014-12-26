# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'delete question', %q{
  In order to remove silly question
  As an author of question
  I want to be able my question if it has not answer
} do

  given(:jack) { create(:user) }
  given(:dave) { create(:user) }
  given(:question) { jack.questions.create(attributes_for(:question)) }

  scenario 'user tries to delete his question' do

    sign_in(jack)
    visit question_path(question)

    click_on "Delete question"

    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'user tries to remove question of another user' do

    sign_in(dave)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'

  end

  scenario 'guest tries to remove question' do

    visit question_path(question)

    expect(page).to_not have_content 'Delete question'

  end

end
