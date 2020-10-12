require 'rails_helper'

RSpec.feature "SignUps", type: :feature do
  include ActiveJob::TestHelper

  scenario "ユーザーはサインアップに成功する" do
    visit root_path
    click_link "新規登録する"

    perform_enqueued_jobs do
      expect {
        fill_in "名前",              with: "Example"
        fill_in "メールアドレス",     with: "test@example.com"
        fill_in "パスワード",         with: "test123"
        fill_in "確認用パスワード",  with: "test123"
        click_button "登録する"
      }.to change(User, :count).by(1)

      expect(page).to have_content "メールをチェックして、アカウントの有効化を行ってください。"
      expect(current_path).to eq root_path
    end

    # 以下はアカウント有効化メールのテストです
    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq ["noreply@example.com"]
      expect(mail.subject).to eq "『誰推しBook』アカウントの有効化"
    end
  end
end