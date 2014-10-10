require 'spec_helper'

describe PasswordsController do
  describe "GET new" do
    it "renders new template" do
      get :new
      expect(response).to render_template :new
    end
  end
  describe "POST create" do
    context "valid email from user" do
      after { ActionMailer::Base.deliveries.clear }
      it "redirects to password confirmation page" do
        joe = Fabricate(:user)
        post :create, email: joe.email
        expect(response).to redirect_to password_confirmation_path
      end
      it "sends an email to the user" do
        joe = Fabricate(:user)
        post :create, email: joe.email
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
    end
    context "blank email" do
      it "flashes error" do
        post :create, email: ""
        expect(flash[:error]).to eq("Email cannot be empty.")
      end
      it "does not send an email" do
        post :create, email: ""
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
    context "invalid email" do
      it "flashes error" do
        bob = Fabricate(:user, email: "bob@example.com")
        post :create, email: "joe@example.com"
        expect(flash[:error]).to eq("Cannot find a user associated with that email.")
      end
      it "does not send an email" do
        bob = Fabricate(:user, email: "bob@example.com")
        post :create, email: "joe@example.com"
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
  describe "GET confirm" do
    it "renders confirm template" do
      get :confirm
      expect(response).to render_template :confirm
    end
  end
end
