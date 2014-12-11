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
  end

  describe 'GET #edit' do
  end

  describe 'PATCH #update' do
  end

  describe 'DELETE #destroy' do
  end


end
