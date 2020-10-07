class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:post]

  def home
    if logged_in?
      # @post  = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    end
  end

  def post
    @post = current_user.posts.build if logged_in?
  end
end
