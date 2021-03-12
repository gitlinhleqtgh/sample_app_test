class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t("micropost_created")
      redirect_to root_path
    else
      @feed_items = current_user.feed.page(params[:page]).per(
        Settings.page.limit
      )
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t ("micropost_deleted")
    redirect_to request.referer || root_path
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end
end
