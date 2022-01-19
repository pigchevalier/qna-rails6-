require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    context 'Not author' do
      let!(:user_not_author) { create(:user) }
      before do
        login(user_not_author)
      end      

      it 'create the vote' do
        expect { post :create, params: {vote:{ value: 1, voteable_id: question.id, voteable_type: question.class}}, format: :json }.to change(question.votes, :count).by(1)
      end
  
      it 'responds with json' do
        post :create, params: {vote:{ value: 1, voteable_id: question.id, voteable_type: question.class}}, format: :json    
        response.body.should == [question.rating, question.votes.first.id].to_json
      end
    end
    context 'Author' do     
      before do
        login(question.user)
      end
  
      it 'not create the vote' do
        expect { post :create, params: {vote:{ value: 1, voteable_id: question.id, voteable_type: question.class}}, format: :json   }.to_not change(question.votes, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    context 'Author' do      
      before do
        login(question.user)
        vote = question.user.votes.build(value: 1, voteable_id: question.id, voteable_type: question.class)
        vote.save
      end      

      it 'not deletes the vote' do
        expect { delete :destroy, params: { id: question.votes.first}, format: :json  }.to_not change(question.votes, :count)
      end
  
    end
    context 'Not author' do
      let!(:user_not_author) { create(:user) }
      before do
        login(user_not_author)
        vote = user_not_author.votes.build(value: 1, voteable_id: question.id, voteable_type: question.class)
        vote.save
      end
  
      it 'deletes the vote' do
        expect { delete :destroy, params: { id: question.votes.first}, format: :json  }.to change(question.votes, :count).by(-1)
      end
  
      it 'responds with json' do
        delete :destroy, params: { id: question.votes.first}, format: :json   
        response.body.should == question.rating.to_json
      end
    end
  end
end
