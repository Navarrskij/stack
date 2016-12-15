shared_examples_for "API Commentable" do

  let!(:comment) { create(:comment, commentable: commentable) }
  let!(:base) { commentable.class.to_s.underscore }

  before { get url_path, format: :json, access_token: access_token.token }

  %w(id body created_at user_id).each do |attr|
    it "comment contains #{attr}" do
      expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("#{base}/comments/0/#{attr}")
    end
  end

  it 'contains comment' do
    expect(response.body).to have_json_size(1).at_path("#{base}/comments")
  end
end