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
    context "succesful user sign up" do
      it "should redirect to the sign in page" do
        result = double(:sign_up_result, successful?: true, error_message: "error")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end
    context "failed user sign up" do
      it "renders new template" do
        result = double(:sign_up_result, successful?: false, error_message: "error")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to render_template :new
      end
      it "flashes error" do
        result = double(:sign_up_result, successful?: false, error_message: "error")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:error]).to be_present
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
