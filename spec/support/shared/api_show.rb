shared_examples_for 'API Show' do
  it "returns 200" do
    expect(response).to be_successful
  end

  it "returns public fields" do
    fields.each do |attr|
      expect(obj_response[attr]).to eq obj.send(attr).as_json
    end        
  end
end
