require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: @user) }
  let(:another_question) { create(:question, user: another_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

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

      it 'render 403 status' do
        expect(response.status).to eq 403
      end
    end

  end

  describe 'PATCH #update' do
    sign_in_user

    context 'user tries to update his question' do
      context 'with valid attributes' do

        it 'assigns requested question as question' do
          patch :update, id: question, question: attributes_for(:question)
          expect(assigns(:question)).to eq question
        end
        
        it 'changes question attributes' do
          patch :update, id: question, question: { title: "new title", body: "new body" }
          question.reload
          expect(question.title).to eq "new title"
          expect(question.body).to eq "new body"
        end
        
        it 'redirect to show template' do
          patch :update, id: question, question: attributes_for(:question)
          expect(response).to redirect_to question
        end  

      end

      context 'with invalid attributes' do
        before { patch :update, id: question, question: attributes_for(:invalid_question) }

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq "MyString"
          expect(question.body).to eq "MyText"
        end

        it 're-render edit template' do
          expect(response).to render_template :edit
        end

      end
    end

    context 'user tries to update another_question' do

      before {patch :update, id: another_question, question: { title: "new title", body: "new body" } }
      
      it 'response status 403' do
        expect(response.status).to eq 403
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

      it 'render 403 status' do
        delete :destroy, id: another_question

        expect(response.status).to eq 403
      end

    end

  end

end
