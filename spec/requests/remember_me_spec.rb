require 'rails_helper'

RSpec.describe "Remember me", type: :request do
  let(:user) { FactoryBot.create(:user) }

  context "2つのバグのテスト1" do
    it "ログイン中のみログアウトすること" do
      sign_in_as(user)     # spec/support/utilities.rbに定義
      expect(response).to redirect_to user_path(user)

      # ログアウトする
      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil

      # 2番目のウィンドウでログアウトする
      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
    end
  end

  context "remember_meチェックボックスのテスト" do
    it "remembers cookies" do
      post login_path, params: { session: { email: user.email,
                                      password: user.password,
                                      remember_me: '1'} }
      expect(response.cookies['remember_token']).to_not eq nil
    end
  end 

  context "remember_meしないでログイン" do
    it "doesn't remember cookies"do
      # クッキーを保存してログイン
      post login_path, params: { session: { email: user.email,
                                      password: user.password,
                                      remember_me: '1'} }
      delete logout_path
      # クッキーを保存せずにログイン
      post login_path, params: { session: { email: user.email,
                                      password: user.password,
                                      remember_me: '0'} }
      expect(response.cookies['remember_token']).to eq nil
    end
  end
end