require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new template" do
      get :new
      response.should render_template :new
    end
    it "redirects to videos_path if already logged in" do
      set_current_user
      get :new
      response.should redirect_to videos_path
    end
  end
  describe "POST create" do
    context "with valid credentials" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
      end
      it "sets session user_id" do
        expect(session[:user_id]).not_to be_nil
      end
      it "redirects to videos path" do
        expect(response).to redirect_to videos_path
      end
      it "sets the notice" do
        expect(flash[:success]).not_to be_blank
      end
    end
    context "without valid credentials" do
      before do
        user = Fabricate(:user)
        post :create, password: 'wrongpass', email: user.email
      end
      it "does not set session" do
        expect(session[:user_id]).to be_nil
      end
      it "redirects to login_path if not authenticated" do
        expect(response).to redirect_to login_path
      end
      it "sets error message" do
        expect(flash[:warning]).not_to be_blank
      end
    end
  end
  describe "GET destroy" do
    before do
      get :destroy
    end
    it "sets session user_id to nil" do
      expect(session[:user_id]).to eq(nil)
    end
    it "redirects to root_path" do
      expect(response).to redirect_to root_path
    end
    it "sets flash notice" do
      expect(flash[:warning]).not_to be_blank
    end
  end
end
