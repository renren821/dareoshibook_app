require 'rails_helper'

RSpec.feature "UserPages", type: :feature do
  describe "signup page" do
    before do
      visit signup_path
    end

    it "新規登録ページに新規登録と表示されていること'" do
      expect(page).to have_content "新規登録"
    end

    it "タイトルが正しく表示されていること" do
      expect(page).to have_title full_title('新規登録')
    end
  end
end