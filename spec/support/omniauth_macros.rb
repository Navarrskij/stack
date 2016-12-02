module OmniauthMacros
  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '1234567',
      info: { email: 'new@new.com' },
         'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'}
    })
  end

  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '1234567',
      info: { email: 'new@new.com'},
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'}
    })
  end

  def mock_auth_facebook_invalid
    OmniAuth.config.mock_auth[:facebook] = :credentials_are_invalid
  end

  def mock_auth_twitter_invalid
    OmniAuth.config.mock_auth[:twitter]  = :credentials_are_invalid
  end
end