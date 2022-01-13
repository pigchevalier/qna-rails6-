require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    context 'Author' do
      let!(:question) { create(:question) }
      before do
        login(question.user)
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end      

      it 'deletes the attached file' do
        expect { delete :destroy, params: { file_id: question.files.first}, format: :js  }.to change(question.files, :count).by(-1)
      end
  
      it 'render destroy' do
        delete :destroy, params: { file_id: question.files.first}, format: :js   
        expect(response).to render_template :destroy
      end
    end
    context 'Not author' do
      let!(:question) { create(:question) }
      let!(:user_not_author) { create(:user) }
      before do
        login(user_not_author)
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
  
      it 'not deletes the question' do
        expect { delete :destroy, params: { file_id: question.files.first}, format: :js  }.to_not change(question.files, :count)
      end
  
      it 'render destroy' do
        delete :destroy, params: { file_id: question.files.first}, format: :js   
        expect(response).to render_template :destroy
      end
    end
  end
end
