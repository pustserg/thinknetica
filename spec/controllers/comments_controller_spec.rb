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

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      
      it 'saves comment in db' do
        expect{ post :create, question_id: question, comment: {body: 'test comment'}, format: :js }.to change(Comment, :count).by(1)
      end

    end

    context 'with invalid attributes' do

      it 'saves comment in db' do
        expect{ post :create, question_id: question, comment: { body: nil }, format: :js }.to_not change(Comment, :count)
      end

    end

  end

end
