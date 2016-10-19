require 'rails_helper'

RSpec.describe User do
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it {should have_many(:answers).dependent(:destroy)}
  it {should have_many(:questions).dependent(:destroy)}

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
 
    context "user is answer author" do
      it { expect(author).to be_author_of(answer) }
    end
 
    context "user is not answer author" do
      it { expect(user2).to_not be_author_of(answer) }
    end
  end
end 