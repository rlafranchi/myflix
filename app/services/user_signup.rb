class UserSignup
  attr_accessor :user, :status, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => stripe_token,
        :description => "MyFlix payment for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information."
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by(token: invitation_token)
    if invitation
      Relationship.create({leader: invitation.user, follower: @user})
      Relationship.create({leader: @user, follower: invitation.user})
      invitation.token = nil
      invitation.save
    end
  end
end
