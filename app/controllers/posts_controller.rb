class PostsController < ApplicationController
  before_action :logged_in_user, only: [:show, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @post_user = User.find(@post.user_id)
    @user = current_user
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿が完了しました！"
      redirect_to current_user
    else
      @feed_items = []
      render 'static_pages/post'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "編集が完了しました。"
      redirect_to current_user
    else
      render 'edit'
    end
  end


  def destroy
    @post.destroy
    @post_user = User.find(@post.user_id)
    flash[:success] = "投稿が削除されました。"
    redirect_to @post_user || root_url
  end

  private

    def post_params
      params.require(:post).permit(:name, :author, :celebrity, :introduction, :reference)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
