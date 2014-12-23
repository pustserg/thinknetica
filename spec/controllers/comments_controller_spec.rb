require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:comment) { create(:question_comment, commentable: question, user: user) }

  sign_in_user

  describe 'GET #new' do
    
    before { xhr :get, :new, question_id: question }

    it 'assigns new Comment as comment' do
      expect(assigns(:comment)).to be_a_new(Comment)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    

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

  describe 'GET #edit' do
    before { xhr :get, :edit, id: comment, format: :js }

    it 'assigns requested comment as resource' do
      expect(assigns(:resource)).to eq comment
    end

    it 'render edit template' do
      expect(response).to render_template :edit
    end

  end

end
