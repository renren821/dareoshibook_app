class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  unless Rails.env.development?
    rescue_from ActiveRecord::RecordNotFound,   with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end
 
  def routing_error
    raise ActionController::RoutingError, params[:path]
  end
 
  private
 
    def render_404
      render 'error/404', status: :not_found
    end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
end
