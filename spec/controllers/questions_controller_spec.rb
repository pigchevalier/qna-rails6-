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

    context 'with invalid attributes' do
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
    it_behaves_like 'DELETE #destroy' do
      let!(:object) { create(:question, user: user) }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'PATCH #update' do
      let!(:object) { create(:question, user: user) }
      let(:params) { {id: object, question: {title: "new title", body: 'new body'}} }
      let(:invalid_params) { {id: object, question: attributes_for(:question, :invalid)} }
      let(:fields) { %w[title body] }
      let(:obj_fields) { {title: "new title", body: 'new body'} }
    end
  end

  describe 'PUT #set_best_answer' do
    let!(:question) { create(:question, user: user) }
    let!(:question_not_author) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, question: question) }

    context 'author set first best answer' do
      before { login(user) }

      it 'change the best answer question' do
        put :set_best_answer, params: { id: question, best_answer_id: answer.id} , format: :js 
        question.reload
        expect(question.best_answer.id).to eq(answer.id)
      end
  
      it 'render set_best_answer' do
        put :set_best_answer, params: { id: question, best_answer_id: answer.id} , format: :js 
        expect(response).to render_template :set_best_answer
      end
    end

    context 'author change best answer' do
      before { login(user) }
      it 'change the best answer question' do
        question.best_answer = answer
        question.save
        put :set_best_answer, params: { id: question, best_answer_id: answer2.id} , format: :js 
        question.reload
        expect(question.best_answer.id).to eq(answer2.id)
      end
  
      it 'render set_best_answer' do
        put :set_best_answer, params: { id: question, best_answer_id: answer2.id} , format: :js 
        expect(response).to render_template :set_best_answer
      end      
    end

    context 'not author' do
      before { login(user_not_author) }
      it 'not change the best answer question' do
        expect { put :set_best_answer, params: { id: question, best_answer_id: answer.id} , format: :js  }.to_not change(question, :best_answer)
      end
  
      it 'render set_best_answer' do
        put :set_best_answer, params: { id: question, best_answer_id: answer2.id} , format: :js 
        expect(response).to render_template :set_best_answer
      end
    end
  end
end
