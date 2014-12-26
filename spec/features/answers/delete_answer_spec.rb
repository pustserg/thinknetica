# -*- encoding : utf-8 -*-
require 'feature_helper'

feature 'delete_answer', %q{
  In order to remove silly answer
  As an author of answer
  I want to be able to delete my answer
} do

  given(:jack) { create(:user) }
  given(:dave) { create(:user) }
  given(:question) { dave.questions.create(attributes_for(:question)) }
  given(:answer) { dave.answers.create(attributes_for(:answer, question_id: question.id)) }

  scenario 'authenticated user tries to delete his answer' do
    sign_in(dave)
    visit question_path(answer.question)

    # save_and_open_page
    click_on 'Delete answer'
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(answer.question)

  end

  scenario 'authenticated user tries to delete answer of another user' do
    sign_in(jack)
    visit question_path(answer.question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'non-authenticated user tries to delete answer' do
    visit question_path(answer.question)

    expect(page).to_not have_content 'Delete answer'
  end

end
