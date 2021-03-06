require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  let(:user) { create(:user) }

  describe 'GET #show' do
    let(:questions) { create_list(:question, 2, user: user) }
    let(:answers) { create_list(:answer, 2, user: user) }
    let(:comments) { create_list(:question_comment, 2, user: user) }
    
    it 'assigns requested user as user' do
      get :show, id: user

      expect(assigns(:user)).to eq user
    end

    it "populates array of questions" do
      get :show, id: questions[0].user

      expect(assigns(:user).questions).to match_array(questions)
    end

    it "populates array of comments" do
      get :show, id: comments[0].user

      expect(assigns(:user).comments).to match_array(comments)
    end

    it 'populates array of answers' do
      get :show, id: answers[0].user

      expect(assigns(:user).answers).to match_array(answers)
    end

    it 'renders show template' do
      get :show, id: user

      expect(response).to render_template :show
    end
  end

end
