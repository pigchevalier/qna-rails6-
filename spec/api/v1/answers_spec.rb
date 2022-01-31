require 'rails_helper'

describe 'Profiles Api', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/answers/:id' do
    let(:access_token) { create(:access_token) }
    let!(:answer) { create(:answer) }
    let(:answer_response) { json["answer"] }
    let!(:comments) { create_list(:comment, 4, commenteable: answer) }
    let!(:links) { create_list(:link, 4, linkable: answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context "authorized" do
      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Show' do
        let(:obj_response) { answer_response }
        let(:obj) { answer.question.answers.first }
        let(:fields) { %w[id body created_at updated_at] }
      end

      it 'contains user' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end 

      it 'contains question' do
        expect(answer_response['question']['id']).to eq answer.question.id
      end

      it_behaves_like 'API Attachments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response["comments"].first }
        let(:comment_response_size) { answer_response["comments"].size }
        let(:link) { links.first }
        let(:link_response) { answer_response["links"].first }
        let(:link_response_size) { answer_response["links"].size }
        let!(:files) { answer.files }
        let(:file) { files.first }
        let(:file_response) { answer_response["files"].first }
        let(:file_response_size) { answer_response["files"].size }
        let(:method) { :get }
        let(:api_path) { "/api/v1/answers/#{answer.id}" }
        let(:obj) { answer }
      end       
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context "authorized" do
      let!(:access_token) { create(:access_token) }
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answer'] }
      let!(:count) { question.answers.count }

      before { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), access_token: access_token.token }.to_json, headers: headers }

      it_behaves_like 'API Show' do
        let(:obj_response) { answer_response }
        let(:obj) { answer }
        let(:fields) { %w[id body created_at updated_at] }
      end

      it 'save a new answer in the db' do
        expect(question.answers.count).to eq count + 1
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:answer) { create(:answer, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context "authorized" do
      let(:answer_response) { json['answer'] }

      before { put "/api/v1/answers/#{answer.id}", params: { answer: { body: 'New body' }, access_token: access_token.token }.to_json, headers: headers }

      it_behaves_like 'API Show' do
        let(:obj_response) { answer_response }
        let(:obj) { answer.question.answers.first }
        let(:fields) { %w[id body created_at updated_at] }
      end

      it 'update answer in the db' do
        expect(answer.question.answers.first.body).to eq 'New body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:answer) { create(:answer, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context "authorized" do
      let(:answers) { answer.question.answers }
      let(:answer_response) { json['question']['answers'] }
      let!(:count) { answer.question.answers.count }

      before { delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }.to_json, headers: headers }

      it "returns 200" do
        expect(response).to be_successful
      end

      it "returns list of answers" do
        expect(answer_response.size).to eq answers.length
      end

      it 'delete a answer in the db' do
        expect(answer.question.answers.count).to eq count - 1
        expect(answer.question.answers.include?(answer)).to be false
      end
    end
  end
end

