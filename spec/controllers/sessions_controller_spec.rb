require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template" do
      get :new
      response.should render_template :new
    end
    it "redirects to videos_path if already logged in" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :new
      response.should redirect_to videos_path
    end
  end
  describe "POST create" do
    it "sets session user_id if authenticated" do
      user = Fabricate(:user)
      post :create, email: user.email, password: user.password
      expect(session[:user_id]).to eq(user.id)
    end
    it "redirects to login_path if not authenticated" do
      user = Fabricate(:user)
      post :create, password: 'wrongpass', email: user.email
      expect(response).to redirect_to login_path
    end
  end
  describe "GET destroy" do
    it "sets session user_id to nil" do
      get :destroy
      expect(session[:user_id]).to eq(nil)
    end
    it "redirects to root_path" do
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end
