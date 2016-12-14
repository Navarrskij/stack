shared_examples_for "API Authenticable" do
   
  context 'unauthorized' do
    method ||= :get
    options = {}

    it 'return 401 status if there is not access_token' do
      do_request(url_path, method, options)
      expect(response.status).to eq 401
    end

    it 'return 401 status if there access_token is invalid' do
      do_request(url_path, method, options.merge(access_token: '112332'))
      expect(response.status).to eq 401
    end
  end
end