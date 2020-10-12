require 'rails_helper'

RSpec.feature "Login", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  scenario "ログインに成功すること" do
    valid_login(user)

    expect(current_path).to eq user_path(user)
    expect(page).to_not have_content "ログインする"
  end

  scenario "無効な情報ではログインに失敗すること" do
    visit root_path
    click_link "ログインする"
    fill_in "メールアドレス", with: ""
    fill_in "パスワード", with: ""
    click_button "ログインする"

    expect(current_path).to eq login_path
    expect(page).to have_content "ログインする"
    expect(page).to have_content "メールアドレスまたはパスワードが正しくありません。"
  end

  scenario "ログインに成功しログアウトすること" do
    valid_login(user)

    expect(current_path).to eq user_path(user)
    expect(page).to_not have_content "ログインする"

    # ログアウトのテスト
    click_link "ログアウトする"

    expect(current_path).to eq root_path
    expect(page).to have_content "ログインする"
  end
end