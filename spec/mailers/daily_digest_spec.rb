require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user, email: "user@test.com") }
    let(:mail) { DailyMailer.digest(user) }
    let!(:question1) { create(:question, title: 'Title1', created_at: Date.yesterday) }
    let!(:question2) { create(:question, title: 'Title2', created_at: Date.yesterday) }

    it "render receiver email" do
      expect(mail.to).to eq(["user@test.com"])
    end

    it "render sender email" do
      expect(mail.from).to eq(["test@example.com"])
    end

    it "render body" do
      [question1, question2].each do |q|
        expect(mail.body.encoded).to have_link(q.title, href: question_url(q))
        expect(mail.body.encoded).to have_content(q.created_at)
      end
    end
  end
end
