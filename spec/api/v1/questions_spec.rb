require 'rails_helper'

describe 'Profiles Api', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context "authorized" do
      let!(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 4, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Show' do
        let(:obj_response) { question_response }
        let(:obj) { question }
        let(:fields) { %w[id title body created_at updated_at] }
      end

      it "returns list of questions" do
        expect(json['questions'].size).to eq questions.length
      end

      it 'contains user' do
        expect(question_response['user']['id']).to eq question.user.id
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question) }
    let(:question_response) { json['question'] }
    let!(:answers) { create_list(:answer, 4, question: question) }
    let!(:comments) { create_list(:comment, 4, commenteable: question) }
    let!(:links) { create_list(:link, 4, linkable: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context "authorized" do
      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Show' do
        let(:obj_response) { question_response }
        let(:obj) { question }
        let(:fields) { %w[id title body created_at updated_at] }
      end

      it 'contains user' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response["answers"].first }

        it "returns list of answers" do
          expect(question_response["answers"].size).to eq answers.length
        end

        it "returns public fields" do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end        
      end

      it_behaves_like 'API Attachments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response["comments"].first }
        let(:comment_response_size) { question_response["comments"].size }
        let(:link) { links.first }
        let(:link_response) { question_response["links"].first }
        let(:link_response_size) { question_response["links"].size }
        let!(:files) { question.files }
        let(:file) { files.first }
        let(:file_response) { question_response["files"].first }
        let(:file_response_size) { question_response["files"].size }
        let(:method) { :get }
        let(:api_path) { "/api/v1/questions/#{question.id}" }
        let(:obj) { question }
      end 
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions' }
    end

    context "authorized" do
      let!(:access_token) { create(:access_token) }
      let(:question) { Question.first }
      let(:question_response) { json['question'] }
      let!(:count) { Question.count }

      before { post '/api/v1/questions', params: { question: attributes_for(:question), access_token: access_token.token }.to_json, headers: headers }

      it_behaves_like 'API Show' do
        let(:obj_response) { question_response }
        let(:obj) { question }
        let(:fields) { %w[id title body created_at updated_at] }
      end

      it 'save a new question in the db' do
        expect(Question.count).to eq count + 1
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context "authorized" do
      let(:question_response) { json['question'] }

      before { put "/api/v1/questions/#{question.id}", params: { question: {title: 'New title', body: 'New body'}, access_token: access_token.token }.to_json, headers: headers }

      it_behaves_like 'API Show' do
        let(:obj_response) { question_response }
        let(:obj) { Question.first }
        let(:fields) { %w[id title body created_at updated_at] }
      end

      it 'update question in the db' do
        expect(Question.first.title).to eq 'New title'
        expect(Question.first.body).to eq 'New body'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context "authorized" do
      let(:questions) { Question.all }
      let(:question_response) { json['questions'] }
      let!(:count) { Question.count }

      before { delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }.to_json, headers: headers }

      it "returns 200" do
        expect(response).to be_successful
      end

      it "returns list of questions" do
        expect(question_response.size).to eq questions.length
      end

      it 'delete a question in the db' do
        expect(Question.count).to eq count - 1
        expect(Question.all.include?(question)).to be false
      end
    end
  end
end
