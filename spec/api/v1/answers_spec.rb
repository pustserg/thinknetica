require 'rails_helper'

describe 'Answers API' do

  let!(:question) { create(:question) }

  describe 'GET /answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:answer_comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachmentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w(body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        %w(id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end

        it 'file is a json object' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments/0/file')
        end

        it 'contains file url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/file/url')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", format: :json
    end

  end

  describe 'POST /create' do
    
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'creates record in db' do
        expect{ post "/api/v1/questions/#{question.id}/answers", question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token }.to change(Answer, :count).by(1)
      end

      it 'should be success' do
        post "/api/v1/questions/#{question.id}/answers", question_id: question, answer: attributes_for(:answer), format: :json, access_token: access_token.token
        expect(response).to be_success
      end

    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", 
        question_id: question, 
        answer: attributes_for(:answer), 
        format: :json
    end
  end

end