require 'rails_helper'

feature 'edit answer', %q{
	In order to improve my answer
	As an authenticated user
	I want to be able to edit my answer
} do
	
	given(:jack) { create(:user) }
	given(:dave) { create(:user) }
	given(:question) { dave.questions.create(attributes_for(:question)) }
	given(:answer) { question.answers.create(attributes_for(:answer, user_id: jack.id)) }
	
	scenario 'authenticated user tries to edit his answer' do
		sign_in(jack)
		visit question_path(answer.question)
		
		click_on 'Edit answer'
		fill_in 'Body', with: 'edited body of test answer' 
		click_on 'Update answer'

		expect(page).to have_content 'edited body of test answer'
		expect(current_path).to eq question_path(answer.question)
	end

	scenario 'authenticated user tries to edit answer of another user' do
		sign_in(dave)
		visit question_path(answer.question)

		expect(page).to_not have_content 'Edit answer'
	end

	scenario 'non-authenticated user tries to edit answer' do
		visit question_path(answer.question)

		expect(page).to_not have_content 'Edit answer'
	end	

end