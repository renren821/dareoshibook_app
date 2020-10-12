require 'rails_helper'

RSpec.feature "Edit", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  scenario "ユーザーは編集に成功する" do
    visit user_path(user)
    valid_login(user)
    click_link user.name

    fill_in "メールアドレス", with: "edit@example.com"
    # fill_in "パスワード", with: user.password, match: :first
    # fill_in "新しいパスワード", with: "test123", match: :first
    # fill_in "新しいパスワード確認", with: "test123"
    click_button "変更する"

    expect(current_path).to eq user_path(user)
    expect(user.reload.email).to eq "edit@example.com"
    # expect(user.reload.password).to eq "test123"
  end

  scenario "ユーザーは編集に失敗する" do
    valid_login(user)
    visit user_path(user)
    click_link user.name

    fill_in "メールアドレス", with: "foo@invalid"
    fill_in "パスワード", with: "foo", match: :first
    click_button "変更する"

    expect(user.reload.email).to_not eq "foo@invalid"
  end
end