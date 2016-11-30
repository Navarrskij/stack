# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#

require 'rails_helper'

RSpec.describe User do
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it {should have_many(:answers).dependent(:destroy)}
  it {should have_many(:questions).dependent(:destroy)}
  it {should have_many(:votes)}

  describe 'user is author?' do
    let(:author) { create(:user) }
    let(:user2) { create(:user) }  
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }
 
    context "user is question author" do
       it { expect(author).to be_author_of(question) }
    end

        context "user is not question author" do
      it { expect(user2).to_not be_author_of(question) }
    end
  end

  describe '.find for oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567') }
    context 'user already has authorization' do
      it 'return the user' do
        user.authorizations.create(provider: 'facebook', uid: '1234567')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end
    context 'user has not authorization' do
      context 'user already exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567', info: { email: user.email }) }
        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end
        it 'create authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
        it 'create authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect( authorization.provider ).to eq auth.provider
          expect( authorization.uid ).to eq auth.uid
        end
        it 'return to user' do
          expect( User.find_for_oauth(auth) ).to eq user
        end
      end
      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567', info: {email: 'new@user.com'} ) }
        it 'creates new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        it 'return new user' do
          expect( User.find_for_oauth(auth) ).to be_a(User) 
        end
        it 'fill user email' do
          user = User.find_for_oauth(auth)
          expect( user.email ).to eq auth.info.email
        end
        it 'create authorization for user' do 
          user = User.find_for_oauth(auth)
          expect( user.authorizations ).to_not be_empty
        end
        it 'create authorization with valid provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect( authorization.provider ).to eq auth.provider
          expect( authorization.uid ).to eq auth.uid
        end
      end
    end
  end
end 
