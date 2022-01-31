shared_examples_for 'DELETE #destroy' do
  context 'Author' do
    before { login(user) }
  
    it 'deletes the object' do
      expect { delete :destroy, params: { id: object}, format: :js  }.to change(object.class, :count).by(-1)
    end
  
    it 'render delete' do
      delete :destroy, params: { id: object}, format: :js 
      expect(response).to render_template :destroy
    end
  end
  context 'Not author' do
    before { login(user_not_author) }
  
    it 'not deletes the object' do
      expect { delete :destroy, params: { id: object}, format: :js  }.to_not change(object.class, :count)
    end
  
    it 'render delete' do
      delete :destroy, params: { id: object}, format: :js 
      expect(response).to render_template :destroy
    end
  end
end

shared_examples_for 'PATCH #update' do
  context 'author, with valid attributes' do
    before { login(user) }

    it 'change the object' do
      patch :update, params: params, format: :js 
      object.reload
      fields.each do |attr|
        expect(object.send(attr)).to eq obj_fields[attr.to_sym]
      end
    end
  
    it 'render update' do
      patch :update, params: params, format: :js
      expect(response).to render_template :update
    end
  end

  context 'author, with invalid attributes' do
    before { login(user) }
    it 'not change the object' do
      expect { patch :update, params: invalid_params, format: :js }.to_not change(object, :body)
    end
  
    it 'render update' do
      patch :update, params: invalid_params, format: :js
      expect(response).to render_template :update
    end
    
  end

  context 'not author' do
    before { login(user_not_author) }
    it 'not change the object' do
      expect { patch :update, params: params, format: :js }.to_not change(object, :body)
    end
  
    it 'render update' do
      patch :update, params: params, format: :js
      expect(response).to render_template :update
    end
  end
end
