require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }

    it "メール送信のテスト" do
      expect(mail.to).to eq ["test5@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "『誰推しBook』アカウントの有効化"
    end

    it "メールプレビューのテスト" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }

    it "メール送信のテスト" do
      user.reset_token = User.new_token
      expect(mail.to).to eq ["test7@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "『誰推しBook』パスワードリセット"
    end

    it "メールプレビューのテスト" do
      user.reset_token = User.new_token
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
end