require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      
      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'questions object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            puts response.body
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:question_comment, commentable: question, user: user) }
      let!(:attachment) { create(:attachment, attachmentable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }  

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end 

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end

        it 'file is a json object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments/0/file')
        end

        it 'contains file url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/file/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", format: :json
    end
  end

  describe 'POST #create' do

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'should be success' do
        post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token
        expect(response).to be_success
      end

      it 'creates new record in db' do
        expect { 
          post '/api/v1/questions', 
          question: attributes_for(:question),
          format: :json, access_token: access_token.token
          }.to change(Question, :count).by(1)
      end

      # context 'returns created question' do
      #   before { post '/api/v1/questions', question: attributes_for(:question), format: :json, access_token: access_token.token }

      #   # %w(id title body created_at updated_at).each do |attr|
      #   #   it "question object contains #{attr}" do
      #   #     expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
      #   #   end
      #   # end 
      # end
    end

    def do_request(options = {})
      post '/api/v1/questions', question: attributes_for(:question), format: :json
    end
  end
end