require "rails_helper"

RSpec.describe AnswerMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user, email: "user@test.com") }
    let(:mail) { AnswerMailer.notify(user, answer) }
    let!(:answer) { create(:answer) }

    it "renders the receiver email" do
      expect(mail.to).to eq(["user@test.com"])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["test@example.com"])
    end

    it "render the body" do
      expect(mail.body.encoded).to have_content(answer.body)
    end
  end
end