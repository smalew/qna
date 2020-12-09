require "rails_helper"

RSpec.describe QuestionsUpdateMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }

    let(:mail) { QuestionsUpdateMailer.notify(user, question, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Updates for question: #{question.title}")
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
