require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do
      before { set_current_user }
      it "sets @video variable" do
        get :show, id: video.id
        assigns(:video).should eq(video)
      end
      it "renders show template" do
        get :show, id: video.id
        response.should render_template :show
      end
      it "sets @reviews variable" do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end
  describe "POST search" do
    it "sets @results for authenticated users" do
      set_current_user
      futurama = Fabricate(:video, name: 'Futurama')
      post :search, search_term: 'rama'
      expect(assigns(:results)).to eq([futurama])
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :search, search_term: 'rama' }
    end
  end
end
