require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  let(:user) { create(:user) }

  describe 'GET #show' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :show, id: questions[0].user }
    
    it 'assigns requested user as user' do
      expect(assigns(:user)).to eq user
    end

    it "populates array of questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

end
