shared_examples_for 'API Attachments' do
  describe 'comments' do    
    it "returns list of comments" do
      expect(comment_response_size).to eq comments.length
    end

    it "returns public fields" do
      %w[id body user_id commenteable_id created_at updated_at].each do |attr|
        expect(comment_response[attr]).to eq comment.send(attr).as_json
      end
    end        
  end

  describe 'links' do
    it "returns list of links" do
      expect(link_response_size).to eq links.length
    end

    it "returns public fields" do
      %w[id name url linkable_id created_at updated_at].each do |attr|
        expect(link_response[attr]).to eq link.send(attr).as_json
      end
    end        
  end

  describe 'files' do
    before do
      obj.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      obj.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    end

    it "returns list of files" do
      expect(file_response_size).to eq files.length
    end

    it "returns public fields" do
      expect(file_response['url']).to eq Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true).as_json
    end        
  end
end
