class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("sented_password_reset")
      redirect_to root_path
    else
      flash.now[:danger] = t("email_address_not_found")
      render :new
    end
  end

  def update
    if user_params[:password].blank?
      @user.errors.add(:password, t("can_cont_empty"))
      render new_password_reset_path
    elsif @user.update user_params
      log_in @user
      flash[:success] = t("password_reseted")
      redirect_to root_path
    else
      render :edit
    end
  end

  private
  def load_user
    return if @user = User.find_by(email: params[:email])

    flash.now[:danger] = t("not_found_user")
    respond_to new_password_reset_path
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
