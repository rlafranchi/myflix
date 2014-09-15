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
      it "should create the user" do
        post :create, user: { email: "email@example.com", password: "password", name: "Name" }
        expect(User.count).to eq(1)
      end
      it "should redirect to the sign in page" do
        post :create, user: { email: "email@example.com", password: "password", name: "Name" }
        expect(response).to redirect_to login_path
      end
    end
    context "with invalid input" do
      it "does not create the user" do
        post :create, user: { email: "", password: "password", name: "Name" }
        expect(User.count).to eq(0)
      end
      it "render the :new template" do
        post :create, user: { email: "", password: "password", name: "Name" }
        expect(response).to render_template :new
      end
      it "sets the @user variable" do
        post :create, user: { email: "", password: "password", name: "Name" }
        expect(assigns(:user)).to be_instance_of(User)
        expect(assigns(:user)).to be_new_record
      end
    end
  end
end
