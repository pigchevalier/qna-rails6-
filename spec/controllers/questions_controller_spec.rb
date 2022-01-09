require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_not_author) { create(:user, email: '2@2.com') }

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save a new question in the db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with valid attributes' do
      it 'doesnt save a new question in the db' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #index' do
    let (:questions) { create_list(:question, 5, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, user: user) }
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }
  
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
      end
  
      it 'redirects to index' do
        delete :destroy, params: { id: question}
        expect(response).to redirect_to questions_path
      end
    end
    context 'Not author' do
      before { login(user_not_author) }
      let!(:question) { create(:question, user: user) }
  
      it 'not deletes the question' do
        expect { delete :destroy, params: { id: question} }.to_not change(Question, :count)
      end
  
      it 'redirects to show' do
        delete :destroy, params: { id: question}
        expect(response).to redirect_to question
      end
    end
  end
end
