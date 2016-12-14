shared_examples_for "API Attachable" do 

  let!(:attachment) { create(:attachment, attachmentable: attachmentable) }
  let!(:base) { attachmentable.class.to_s.underscore }

  before { get url_path, format: :json, access_token: access_token.token }

  %w(id created_at).each do |attr|
    it "answer attachment contains #{attr}" do
      expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("#{base}/attachments/0/#{attr}")
    end
  end

  it 'contains attachment' do
    expect(response.body).to have_json_size(1).at_path("#{base}/attachments")
  end

  it "answer attachment contains file name" do
    expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("#{base}/attachments/0/name")
  end

  it "answer attachment contains url path" do
    expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{base}/attachments/0/path")
  end
end