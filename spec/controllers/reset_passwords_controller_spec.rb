require 'spec_helper'

describe ResetPasswordsController do
  describe "GET show" do
    it "renders show template with valid token" do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(response).to render_template :show
    end
    it "sets @token" do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(assigns(:token)).to eq(user.token)
    end
    it "redirects to expired token page with invalid token" do
      user = Fabricate(:user)
      get :show, id: '31124g'
      expect(response).to redirect_to expired_token_path
    end
  end
  describe "POST create" do
    context "with valid input" do
      it "updates the users password" do
        user = Fabricate(:user)
        user.update_column(:token, '12345')
        post :create, token: '12345', password: "newpassword"
        user.reload
        expect(user.authenticate('newpassword')).to eq(user)
      end
      it "redirects to log in path" do
        user = Fabricate(:user)
        post :create, token: user.token, password: "newpassword"
        expect(response).to redirect_to login_path
      end
      it "sets flash success" do
        user = Fabricate(:user)
        post :create, token: user.token, password: "newpassword"
        expect(flash[:success]).to be_truthy
      end
      it "regenerates token" do
        user = Fabricate(:user)
        user.update_column(:token, '12345')
        post :create, token: user.token, password: "newpassword"
        expect(user.reload.token).to_not eq('12345')
      end
    end
    context "invalid input" do
      it "renders show template" do
        user = Fabricate(:user)
        post :create, token: user.token, password: ""
        expect(response).to render_template "show"
      end
      it "flashes error" do
        user = Fabricate(:user)
        post :create, token: user.token, password: ""
        expect(flash[:error]).to be_truthy
      end
    end
  end
end
