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

    context 'with valid attributes' do
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
    let!(:answer) { create(:answer, question: question, user: user) }
    context 'Author' do
      before { login(user) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js  }.to change(Answer, :count).by(-1)
      end
  
      it 'render delete' do
        delete :destroy, params: { id: answer }, format: :js 
        expect(response).to render_template :destroy
      end
    end
    context 'Not author' do
      before { login(user_not_author) }
      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js  }.to_not change(Answer, :count)
      end
  
      it 'render delete' do
        delete :destroy, params: { id: answer }, format: :js 
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'author, with valid attributes' do
      before { login(user) }

      it 'change the answer' do
        patch :update, params: { id: answer, answer: {body: 'new body'} } , format: :js 
        answer.reload
        expect(answer.body).to eq('new body')
      end
  
      it 'render update' do
        patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'author, with invalid attributes' do
      before { login(user) }
      it 'not change the answer' do
        expect { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(answer, :body)
      end
  
      it 'render update' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
      
    end

    context 'not author' do
      before { login(user_not_author) }
      it 'not change the answer' do
        expect { patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js }.to_not change(answer, :body)
      end
  
      it 'render update' do
        patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #remove_attached_file' do
    context 'Author' do
      let!(:answer) { create(:answer, question: question, user: user) }
      before do
        login(user)
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end      

      it 'deletes the attached file' do
        expect { delete :delete_file_attachment, params: { id: answer, question_id: question, file_id: answer.files.first}, format: :js  }.to change(answer.files, :count).by(-1)
      end
  
      it 'render delete_file_attachment' do
        delete :delete_file_attachment, params: { id: answer, question_id: question, file_id: answer.files.first}, format: :js   
        expect(response).to render_template :delete_file_attachment
      end
    end
    context 'Not author' do
      let!(:answer) { create(:answer, question: question, user: user) }
      before do
        login(user_not_author)
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
  
      it 'not deletes the question' do
        expect { delete :delete_file_attachment, params: { id: answer, question_id: question, file_id: answer.files.first}, format: :js  }.to_not change(answer.files, :count)
      end
  
      it 'render delete_file_attachment' do
        delete :delete_file_attachment, params: { id: answer, question_id: question, file_id: answer.files.first}, format: :js   
        expect(response).to render_template :delete_file_attachment
      end
    end
  end
end
