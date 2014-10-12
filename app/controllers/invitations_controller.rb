class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end
  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = current_user
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "Invitation sent"
      redirect_to new_invitation_path
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name, :message, :email)
  end
end
