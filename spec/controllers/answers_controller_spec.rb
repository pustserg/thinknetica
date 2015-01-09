# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:another_question) { create(:question, user: another_user) }
  let(:answer) { create(:answer, user: @user, question: question) }
  let(:another_answer) { create(:answer, user: another_user, question: another_question) }

  describe 'GET #show' do
    before { another_answer }

    it 'redirects to question' do
      get :show, id: another_answer

      expect(response).to redirect_to another_answer.question
    end

  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do

      it 'saves answer in db' do
        expect{ 
          post :create, question_id: question, answer: attributes_for(:answer), format: :js 
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to answer question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end

    end

    context 'with invalid attributes' do
      
      it 'does not saves answer in db' do
        expect{
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end

    end

  end

  describe 'GET #edit' do
    sign_in_user

    context 'author tries to edit his answer' do
      before { xhr :get, :edit, id: answer, format: :js }

      it 'assigns requested answer as @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'render edit view' do
        expect(response).to render_template :edit
      end

    end

    context 'user tries to edit another_answer' do
      before { xhr :get, :edit, id: another_answer, format: :js }

      it 'does not render edit view' do
        expect(response).to_not render_template :edit
      end

      it 'render 403 status' do
        expect(response.status).to eq 403
      end

    end

  end

  describe 'PATCH #update' do
    sign_in_user

    context 'author tries to update his answer' do

      context 'with valid attributes' do

        it 'assigns requested answer as answer' do
          patch :update, question_id: answer.question, id: answer, answer: attributes_for(:answer), format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, question_id: answer.question, id: answer, answer: { body: "new body"}, format: :js
          answer.reload
          expect(answer.body).to eq "new body"
        end

        it 'redirects to answer' do
          patch :update, question_id: answer.question, id: answer, answer: attributes_for(:answer), format: :js
          expect(response).to render_template :update
        end

      end

      context 'with invalid attributes' do
        before {
          patch :update, question_id: answer.question, id: answer, answer: attributes_for(:invalid_answer), format: :js
        }

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.body).to eq "my answer"
        end

        it 'render update view' do
          expect(response).to render_template :update
        end

      end

    end

    context 'user tries to update another_answer' do

      it 'response status 403' do
        patch :update, question_id: another_answer.question, id: another_answer, answer: { body: 'new body' }, format: :js

        expect(response.status).to eq 403
      end

    end

  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'author tries to delete his answer' do
      before { answer }

      it 'deletes answer from db' do
        expect{ delete :destroy, question_id: answer.question, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'redirect to answer answer.question' do
        question = answer.question
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'user tries to delete another answer' do
      before { another_answer }

      it 'does not deletes answer from db' do
        expect{ delete :destroy, question_id: another_answer.question, id: another_answer }.to_not change(Answer, :count)
      end

    end

  end

  describe 'patch #make_best' do
    sign_in_user
    context 'question author tries to mark answer as best' do
      before { patch :make_best, id: answer }

      it 'change best_attribute for answer' do
        answer.reload
        
        expect(answer.best).to be true
        expect(answer.question.answered).to be true
      end
    end

    context 'user tries to mark answer as best' do
      before { patch :make_best, id: another_answer }

      it 'does not change best_attribute for answer' do
        another_answer.reload

        expect(another_answer.best).to be false
      end
    end

  end

  describe 'PATCH #vote_up' do
    sign_in_user

    context 'answer author tries to vote_up answer' do
      it "does not creates a new vote" do
        expect{ patch :vote_up, id: answer }.to_not change(answer.votes, :count)
      end

      it 'response status must be 403' do
        patch :vote_up, id: answer
        
        expect(response.status).to eq 403
      end  
    end

    context 'another user tries to vote_up answer' do
      it 'create a new vote' do
        expect{ patch :vote_up, id: another_answer }.to change(another_answer.votes, :count)
      end
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user

    context 'answer author tries to vote_down answer' do
      it "does not creates a new vote" do
        expect{ patch :vote_down, id: answer }.to_not change(answer.votes, :count)
      end

      it 'response status must be 403' do
        patch :vote_down, id: answer
        
        expect(response.status).to eq 403
      end  
    end

    context 'another user tries to vote_down answer' do
      it 'create a new vote' do
        expect{ patch :vote_down, id: another_answer }.to change(another_answer.votes, :count)
      end
    end
  end


end
