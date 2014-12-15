require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let(:user) { create(:user) }
  let(:question) { user.questions.create(attributes_for(:question)) }
  let(:answer) { user.answers.create(attributes_for(:answer, question_id: question.id)) }

  describe 'GET #show' do
    before { get :show, question_id: answer.question, id: answer }

    it 'assign requested answer as @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question }

    it 'assigns new answer as @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do

      it 'saves answer in db' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it 'redirects to answer question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:answer).question)
      end

    end

    context 'with invalid attributes' do
      
      it 'does not saves answer in db' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end

    end

  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, question_id: answer.question, id: answer }

    it 'assigns requested answer as @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end

  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do

      it 'assigns requested answer as answer' do
        patch :update, question_id: answer.question, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, question_id: answer.question, id: answer, answer: { body: "new body"}
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it 'redirects to answer' do
        patch :update, question_id: answer.question, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to answer.question
      end

    end

    context 'with invalid attributes' do
      before { patch :update, question_id: answer.question, id: answer, answer: attributes_for(:invalid_answer) }

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq "my answer"
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end

    end

  end

  describe 'DELETE #destroy' do
    sign_in_user
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


end
