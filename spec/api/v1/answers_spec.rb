require 'rails_helper'

describe 'Answers API' do

  describe 'GET /answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    context 'unauthorized' do

      it 'returns 401 when there not access token' do
        get "/api/v1/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 when access token is invalid' do
        get "/api/v1/answers/#{answer.id}", format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end

    end

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

  end

end