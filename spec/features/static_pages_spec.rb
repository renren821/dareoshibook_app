require 'rails_helper'

RSpec.feature "StaticPages", type: :feature do
  describe "Home page" do
    before do
      visit root_path   # 名前付きルートを使用
    end

    it "Homeページに誰推しBookと表示されていること" do
      expect(page).to have_content "誰推しBook"
    end

    it "タイトルが正しく表示されていること" do
      expect(page).to have_title full_title('')
    end
  end
end
