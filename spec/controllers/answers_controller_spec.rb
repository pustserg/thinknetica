require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let(:answer) { create(:answer) }

  describe 'GET #show' do
    before { get :show, id: answer }

    it 'assign requested answer as @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end

  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new answer as @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves answer in db' do
        expect{ post :create, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it 'redirects to answer' do
        post :create, answer: attributes_for(:answer)
        expect(response).to redirect_to answer_path(assigns(:answer))
      end

    end

    context 'with invalid attributes' do
      
      it 'does not saves answer in db' do
        expect{ post :create, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end

    end

  end

  describe 'GET #edit' do
    before { get :edit, id: answer }

    it 'assigns requested answer as @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end

  end

  describe 'PATCH #update' do
    context 'with valid attributes' do

      it 'assigns requested answer as answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: answer, answer: { body: "new body"}
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it 'redirects to answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to answer
      end

    end

    context 'with invalid attributes' do
      before { patch :update, id: answer, answer: attributes_for(:invalid_answer) }

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
    before { answer }

    it 'deletes answer from db' do
      expect{ delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end
  end


end
