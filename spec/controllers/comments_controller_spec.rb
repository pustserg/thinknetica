require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:comment) { create(:question_comment, commentable: question, user: @user) }
  let(:another_comment) { create(:question_comment, commentable: question, user: another_user) }

  sign_in_user

  describe 'GET #new' do
    
    before { xhr :get, :new, question_id: question }

    it 'assigns new Comment as resource' do
      expect(assigns(:resource)).to be_a_new(Comment)
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

  describe 'PATCH #update' do

    context 'user tries to update his comment' do

      context 'with valid attributes' do

        it 'assigns requested comment as resource' do
          patch :update, id: comment ,comment: attributes_for(:question_comment), format: :js
          expect(assigns(:resource)).to eq comment
        end

        it 'changes commen attributes' do
          patch :update, id: comment, comment: { body: 'edited comment' }, format: :js
          
          comment.reload

          expect(comment.body).to eq 'edited comment'
        end

      end

      context 'with invalid attributes' do
        before { patch :update, id: comment ,comment: { body: nil }, format: :js }

        it 'does not change comment attributes' do
          comment.reload

          expect(comment.body).to eq 'question comment'
        end

      end

    end

    context 'user tries to update another user comment' do
      before { patch :update, id: another_comment, comment: { body: "edited body" }, format: :js }

      it 'response status must be 403' do
        expect(response.status).to eq 403
      end
    end

  end

  describe 'DELETE #destroy' do

    context 'user tries to delete another user comment' do
      before { another_comment }

      it 'should not change Comment count' do
        expect{ delete :update, id: another_comment }.to_not change(Comment, :count)
      end

      it 'response status must be 403' do
        delete :update, id: another_comment
        expect(response.status).to eq 403
      end
    end

    context 'user tries to delete his comment' do
      before { comment }

      it 'should change Comment count' do
        expect{ delete :destroy, id: comment }.to change(Comment, :count).by(-1)
      end

      it 'redirect to commentable' do
        commentable = comment.commentable
        delete :destroy, id: comment

        expect(response).to redirect_to commentable
      end
    end

  end

end
