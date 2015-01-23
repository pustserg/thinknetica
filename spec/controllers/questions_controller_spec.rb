# -*- encoding : utf-8 -*-
require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:another_question) { create(:question, user: another_user) }

  before(:each) { request.env["HTTP_REFERER"] = "where_i_came_from" unless request.nil? or request.env.nil? }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user, tag_list: "first, second") }

    before { get :index }

    it "populates array of questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: another_question }

    it 'assigns requested question as @question' do
      expect(assigns(:question)).to eq another_question
    end

    it 'assigns a new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render template show' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns new Question to question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render template new' do
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      
      it 'saves a question in the db' do
        expect{ post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

    end

    context 'with invalid attributes' do
      
      it 'does not save a question in the db' do
        expect{ post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 'render template new' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end

    end
  end

  describe 'GET #edit' do
    sign_in_user
    
    context 'user tries to edit his question' do
      before { get :edit, id: question }

      it 'assigns requested question as question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders template edit' do
        expect(response).to render_template :edit
      end
    
    end

    context 'another_question' do
      before { get :edit, id: another_question }

      it 'does not render edit view' do
        expect(response).to_not render_template :edit
      end

      it 'render 302 status' do
        expect(response.status).to eq 302
      end
    end

  end

  describe 'PATCH #update' do
    sign_in_user

    context 'user tries to update his question' do
      context 'with valid attributes' do

        it 'assigns requested question as question' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(assigns(:question)).to eq question
        end
        
        it 'changes question attributes' do
          patch :update, id: question, question: { title: "new title", body: "new body" }, format: :js
          question.reload
          expect(question.title).to eq "new title"
          expect(question.body).to eq "new body"
        end
        
        it 'redirect to show template' do
          patch :update, id: question, question: attributes_for(:question), format: :js
          expect(response).to render_template :update
        end  

      end

      context 'with invalid attributes' do
        before { patch :update, id: question, question: attributes_for(:invalid_question), format: :js }

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq "MyString"
          expect(question.body).to eq "MyText"
        end

        it 'render view template' do
          expect(response).to render_template :update
        end

      end
    end

    context 'user tries to update another_question' do

      before {patch :update, id: another_question, question: { title: "new title", body: "new body" }, format: :js }
      
      it 'response status 302' do
        expect(response.status).to eq 302
      end

    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    
    context 'author tries to delete his question' do
      before { question }

      it 'deletes question from db' do
        expect{ delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end

    end

    context 'another user tries to delete question' do
      before { another_question }

      it 'does not deletes question from db' do
        expect{ delete :destroy, id: another_question }.to_not change(Question, :count)
      end

      it 'render 302 status' do
        delete :destroy, id: another_question

        expect(response.status).to eq 302
      end

    end

  end

  describe 'PATCH #vote_up' do
    sign_in_user

    context 'question author tries to vote_up question' do
      it "does not creates a new vote" do
        expect{ patch :vote_up, id: question }.to_not change(question.votes, :count)
      end

      it 'response status must be 302' do
        patch :vote_up, id: question
        
        expect(response.status).to eq 302
      end  
    end

    context 'another user tries to vote_up question' do
      it 'create a new vote' do
        expect{ patch :vote_up, id: another_question }.to change(another_question.votes, :count)
      end
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user

    context 'question author tries to vote_down question' do
      it "does not creates a new vote" do
        expect{ patch :vote_down, id: question }.to_not change(question.votes, :count)
      end

      it 'response status must be 302' do
        patch :vote_down, id: question
        
        expect(response.status).to eq 302
      end  
    end

    context 'another user tries to vote_down question' do
      it 'create a new vote' do
        expect{ patch :vote_down, id: another_question }.to change(another_question.votes, :count)
      end
    end
  end

end
