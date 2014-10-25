require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user variable" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
    it "sets :user to be new record" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end
  describe "POST create" do
    context "with valid input" do
      before do
        StripeWrapper::Charge.stub(:create)
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "should create the user" do
        expect(User.count).to eq(1)
      end
      it "should redirect to the sign in page" do
        expect(response).to redirect_to login_path
      end
      context "invitations" do
        it "creates relationships between inviter and invitee with valid token" do
          inviter = Fabricate(:user)
          invitation = Fabricate(:invitation, user_id: inviter.id)
          post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
          expect(Relationship.count).to eq(2)
        end
        it "does not create relationship for invalid token" do
          post :create, user: Fabricate.attributes_for(:user), invitation_token: '123abc'
          expect(Relationship.count).to eq(0)
        end
        it "expires token upon creation" do
          inviter = Fabricate(:user)
          invitation = Fabricate(:invitation, user_id: inviter.id)
          post :create, user: Fabricate.attributes_for(:user), invitation_token: invitation.token
          expect(invitation.reload.token).to be_nil
        end
      end
    end
    context "with invalid input" do
      before do
        post :create, user: { email: "", password: "password", name: "Name" }
      end
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it "render the :new template" do
        expect(response).to render_template :new
      end
      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
        expect(assigns(:user)).to be_new_record
      end
    end
    context "email sending" do
      context "valid input" do
        after { ActionMailer::Base.deliveries.clear }
        before do
          StripeWrapper::Charge.stub(:create)
          post :create, user: Fabricate.attributes_for(:user)
        end
        it "sends email" do
          ActionMailer::Base.deliveries.should_not be_empty
        end
        it "sends to recipient" do
          message = ActionMailer::Base.deliveries.last
          message.to.should eq([User.first.email])
        end
        it "has the right content" do
          message = ActionMailer::Base.deliveries.last
          message.body.should include(User.first.name)
        end
      end
      context "invalid input" do
        it "does not send an email" do
          post :create, user: {email: "", password: "", name: ""}
          ActionMailer::Base.deliveries.should be_empty
        end
      end
    end
  end
  describe "GET show" do
    context "with authenticated users" do
      let(:bob) { Fabricate(:user) }
      before { set_current_user }
      it "renders show template" do
        get :show, id: bob.id
        expect(response).to render_template :show
      end
      it "sets @user variable" do
        get :show, id: bob.id
        expect(assigns(:user)).to eq(bob)
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end
  end
  describe "GET new_invitation_with_token" do
    let(:invitation) { Fabricate(:invitation) }
    context "valid token" do
      before { get :new_invitation_with_token, token: invitation.token }
      it "renders new template" do
        expect(response).to render_template :new
      end
      it "sets @user with name and email from invitation" do
        expect(assigns(:user).email).to eq(invitation.email)
        expect(assigns(:user).name).to eq(invitation.name)
      end
      it "sets @invitation_token" do
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end
    end
    it "redirects to expired token path with invalid token" do
      get :new_invitation_with_token, token: 'abc123'
      expect(response).to redirect_to expired_token_path
    end
  end
end
