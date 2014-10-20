require 'spec_helper'
require 'pry'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
    it "sets @video to new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end
    it "redirects regular user to home path" do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end
    it "sets flash error for regular user" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end
  end
end
