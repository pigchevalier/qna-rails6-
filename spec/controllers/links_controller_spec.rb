require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    context 'Author' do
      let!(:question) { create(:question) }
      before do
        login(question.user)
        question.links.build(name: 'url', url: 'https://gist.github.com/pigchevalier/d11aa8d32efd95c437fe983aa5d675bc')
        question.save
      end      

      it 'deletes the link' do
        expect { delete :destroy, params: { id: question.links.first}, format: :js  }.to change(question.links, :count).by(-1)
      end
  
      it 'render destroy' do
        delete :destroy, params: { id: question.links.first}, format: :js   
        expect(response).to render_template :destroy
      end
    end
    context 'Not author' do
      let!(:question) { create(:question) }
      let!(:user_not_author) { create(:user) }
      before do
        login(user_not_author)
        question.links.build(name: 'url', url: 'https://gist.github.com/pigchevalier/d11aa8d32efd95c437fe983aa5d675bc')
        question.save
      end
  
      it 'not deletes the link' do
        expect { delete :destroy, params: { id: question.links.first}, format: :js  }.to_not change(question.links, :count)
      end
  
      it 'render destroy' do
        delete :destroy, params: { id: question.links.first}, format: :js   
        expect(response).to render_template :destroy
      end
    end
  end
end
