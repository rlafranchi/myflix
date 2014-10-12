require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    context "authenticated users" do
      let(:bob) { current_user }
      before { set_current_user }
      it "renders new template" do
        get :new
        expect(response).to render_template :new
      end
      it "sets @invitation variable as new record" do
        get :new
        expect(assigns(:invitation)).to be_new_record
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end
  describe "POST create" do
    context "authenticated users" do
      let(:bob) { current_user }
      before { set_current_user }
      context "with valid input" do
        before { post :create, invitation: {email: "joe@example.com", name: "Joe Schmoe", message: "Hey Joe"} }
        after { ActionMailer::Base.deliveries.clear }
        it "redirects to videos path" do
          expect(response).to redirect_to new_invitation_path
        end
        it "flashes success message" do
          expect(flash[:success]).to be_truthy
        end
        it "creates the invitation" do
          expect(Invitation.count).to eq(1)
        end
        it "sends an email to the invitee" do
          message = ActionMailer::Base.deliveries.last
          message.to.should eq(["joe@example.com"])
        end
      end
      context "invalid input" do
        before { post :create, invitation: {email: "", name: "Joe Schmoe", message: "Hey Joe"} }
        it "does not create the invitation" do
          expect(Invitation.count).to eq(0)
        end
        it "renders new template" do
          expect(response).to render_template :new
        end
        it "sets @invitation" do
          expect(assigns(:invitation)).to be_instance_of(Invitation)
        end
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { post :create, invitation: {email: "joe@example.com", name: "Joe Schmoe", message: "Hey Joe" } }
    end
  end
end
