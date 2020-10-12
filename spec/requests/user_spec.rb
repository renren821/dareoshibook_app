require 'rails_helper'

RSpec.describe "User pages", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  # new
  describe "GET #new" do
    it "正常なレスポンスを返すこと" do
      get signup_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end

  describe "GET #show" do

    context "ログイン済みのユーザーとして" do
      it "正常なレスポンスを返すこと" do
        sign_in_as user
        get user_path(user)
        expect(response).to be_success
        expect(response).to have_http_status "200"
      end
    end

    context "ログインしていないユーザーの場合" do 
      it "ログイン画面にリダイレクトすること" do
        get user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context "アカウントが違うユーザーの場合" do 
      before do
        @other_user = FactoryBot.create(:user)
      end

      it "ホーム画面にリダイレクトすること" do
        sign_in_as @other_user
        get user_path(user)
      end
    end
  end

  describe "#create" do
    include ActiveJob::TestHelper

    it "is invalid with invalid signup information" do
      perform_enqueued_jobs do
        expect {
          post users_path, params: { user: { name: "",
                                            email: "user@invalid",
                                            password: "foo",
                                            password_confirmation: "bar" } }
        }.to_not change(User, :count)
      end
    end

    it "is valid with valid signup information" do
      perform_enqueued_jobs do
        expect {
          post users_path, params: { user: { name: "ExampleUser",
                                            email: "user@example.com",
                                            password: "password",
                                            password_confirmation: "password" } }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to root_path
        user = assigns(:user)    # gem 'rails-controller-testing'をインストール
        # 有効化していない状態でログインしてみる
        sign_in_as(user)
        expect(session[:user_id]).to be_falsey
        # 有効化トークンが不正な場合
        get edit_account_activation_path("invalid token", email: user.email)
        expect(session[:user_id]).to be_falsey
        # トークンは正しいがメールアドレスが無効な場合
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        expect(session[:user_id]).to be_falsey
        # 有効化トークンが正しい場合
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(session[:user_id]).to eq user.id
        expect(user.name).to eq "ExampleUser"
        expect(user.email).to eq "user@example.com"
        expect(user.password).to eq "password"
      end
    end
  end

  describe "#edit" do
    context "認可されたユーザーとして" do
      it "responds successfully" do
        sign_in_as user
        get edit_user_path(user)
        expect(response).to be_success
        expect(response).to have_http_status "200"
      end
    end

    context "ログインしていないユーザーの場合" do 
      it "ログイン画面にリダイレクトすること" do
        get edit_user_path(user)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end

    context "アカウントが違うユーザーの場合" do 
      it "ホーム画面にリダイレクトすること" do
        sign_in_as other_user
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    context "認可されたユーザーとして" do
      it "ユーザーを更新できること" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq "NewName"
      end
    end

    context "ログインしていないユーザーの場合" do 
      it "ログイン画面にリダイレクトすること" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end

    context "アカウントが違うユーザーの場合" do 
      it "ユーザーを更新できないこと" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq other_user.name
      end

      it "ホーム画面にリダイレクトすること" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "#edit" do
    context "認可されたユーザーとして" do
      it "responds successfully" do
        sign_in_as user
        get edit_user_path(user)
        expect(response).to be_success
        expect(response).to have_http_status "200"
      end
    end

    context "ログインしていないユーザーの場合" do 
      it "ログイン画面にリダイレクトすること" do
        get edit_user_path(user)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end

    context "アカウントが違うユーザーの場合" do 
      it "ホーム画面にリダイレクトすること" do
        sign_in_as other_user
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    context "認可されたユーザーとして" do
      it "ユーザーを更新できること" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq "NewName"
      end
    end

    context "ログインしていないユーザーの場合" do 
      it "ログイン画面にリダイレクトすること" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end

    context "アカウントが違うユーザーの場合" do 
      it "ユーザーを更新できないこと" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq other_user.name
      end

      it "ホーム画面にリダイレクトすること" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    context "認可されたユーザーとしてr" do
      it "ユーザーを削除できること" do
        sign_in_as user
        expect {
          delete user_path(user), params: { id: user.id }
        }.to change(User, :count).by(-1)
      end
    end

    context "アカウントの違うユーザーの場合" do
      it "ホーム画面にリダイレクトすること" do
        sign_in_as other_user
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to root_path
      end
    end

    context "ゲストとして" do
      it "returns a 302 response" do
        delete user_path(user), params: { id: user.id }
        expect(response).to have_http_status "302"
      end

      it "ログインページにリダイレクトすること" do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to login_path
      end
    end
  end
end