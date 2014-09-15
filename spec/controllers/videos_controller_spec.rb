require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
      end
      it "sets @video variable" do
        video = Fabricate(:video)
        get :show, id: video.id
        assigns(:video).should eq(video)
      end
      it "renders show template" do
        video = Fabricate(:video)
        get :show, id: video.id
        response.should render_template :show
      end
    end
  end
  describe "POST search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, name: 'Futurama')
      post :search, search_term: 'rama'
      expect(assigns(:results)).to eq([futurama])
    end

    it "redirects to sign in page for unauthenticated users" do
      futurama = Fabricate(:video, name: 'Futurama')
      post :search, search_term: 'rama'
      expect(response).to redirect_to login_path
    end
  end
end
