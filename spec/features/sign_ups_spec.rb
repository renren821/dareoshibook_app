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
    end
  end
end