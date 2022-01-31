require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_not_author) { create(:user, email: '2@2.com') }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'save a new answer in the db' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js }.to change(Answer, :count).by(1)
      end

      it 'render create' do
        post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js 
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save a new answer in the db' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }, format: :js  }.to_not change(Answer, :count)
      end

      it 'render create' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }, format: :js 
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do 
    it_behaves_like 'DELETE #destroy' do
      let!(:object) { create(:answer, question: question, user: user) }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'PATCH #update' do
      let!(:object) { create(:answer, question: question, user: user) }
      let(:params) { {id: object, answer: {body: 'new body'}} }
      let(:invalid_params) { {id: object, answer: attributes_for(:answer, :invalid)} }
      let(:fields) { %w[body] }
      let(:obj_fields) { {body: 'new body'} }
    end
  end
end
