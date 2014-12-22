require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #new' do
    sign_in_user
    before { xhr :get, :new, question_id: question }

    it 'assigns new Comment as comment' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end

  end

end
