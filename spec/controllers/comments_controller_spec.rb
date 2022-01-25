require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    context 'Auth user' do
      before do
        login(question.user)
      end      

      it 'create the vote' do
        expect { post :create, params: {body: 'qwe', question_id: question.id}, format: :js }.to change(question.comments, :count).by(1)
      end
  
      it 'render create' do
        post :create, params: {body: 'qwe', question_id: question.id}, format: :js   
        expect(response).to render_template :create
      end
    end
    context 'Not auth user' do     
      it ' not create the vote' do
        expect { post :create, params: {body: 'qwe', question_id: question.id}, format: :json }.to_not change(question.comments, :count)
      end
    end
  end
end
