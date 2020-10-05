require 'rails_helper'

RSpec.describe "User pages", type: :request do
  let(:user) { FactoryBot.create(:user) }

  # new
  describe "GET #new" do
    it "正常なレスポンスを返すこと" do
      get signup_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end
end