class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_invitation_with_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @invitation_token = invitation.token
      @user = User.new(email: invitation.email, name: invitation.name)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(stripe_token_param, token_param)
    if result.successful?
      flash[:success] = "Thank You for signing up! Please sign in."
      redirect_to login_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :email)
  end

  def token_param
    params[:invitation_token]
  end

  def stripe_token_param
    params[:stripeToken]
  end

end
