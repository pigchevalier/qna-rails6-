require 'rails_helper'

RSpec.describe SubsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    context 'Authen. user' do
      before do
        login(question.user)
      end      

      it 'create the sub' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to change(question.subs, :count).by(1)
      end
  
      it 'render create' do
        post :create, params: { question_id: question.id }, format: :js   
        expect(response).to render_template :create
      end
    end
    context 'Not authen. user' do     
      it ' not create the subs' do
        expect { post :create, params: { question_id: question.id }, format: :json }.to_not change(question.subs, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Author' do
      let!(:sub) { create(:sub) }
      before do
        login(sub.user)
      end      

      it 'deletes the sub' do
        expect { delete :destroy, params: { id: sub, question_id: sub.question }, format: :js  }.to change(sub.question.subs, :count).by(-1)
      end
  
      it 'render destroy' do
        delete :destroy, params: { id: sub, question_id: sub.question }, format: :js 
        expect(response).to render_template :destroy
      end
    end
    context 'Not author' do
      let!(:sub) { create(:sub) }
      let!(:user_not_author) { create(:user) }
      before do
        login(user_not_author)
      end
  
      it 'not deletes the sub' do
        expect { delete :destroy, params: { id: sub, question_id: sub.question }, format: :js  }.to_not change(sub.question.subs, :count)
      end
  
      it 'render destroy' do
        delete :destroy, params: { id: sub, question_id: sub.question }, format: :js 
        expect(response).to render_template :destroy
      end
    end
  end
end
