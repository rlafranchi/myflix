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
    invitation = Invitation.find_by(token: token_param)
    if @user.save
      if invitation
        Relationship.create({leader: invitation.user, follower: @user})
        Relationship.create({leader: @user, follower: invitation.user})
        invitation.token = nil
        invitation.save
      end

      begin
        charge = Stripe::Charge.create(
          :amount => 999,
          :currency => "usd",
          :card => stripe_token_param,
          :description => "MyFlix payment for #{@user.email}"
        )
        AppMailer.delay.send_welcome_email(@user)
        redirect_to login_path
      rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to register_path
      end
    else
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
