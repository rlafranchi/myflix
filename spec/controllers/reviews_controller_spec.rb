require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video)}
    context "with authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with valid input" do
        before { post :create, review: Fabricate.attributes_for(:review), video_id: video.id }
        it "redirects back to same page" do
          expect(response).to redirect_to video
        end
        it "should create a review" do
          expect(Review.count).to eq(1)
        end
        it "associates review with video" do
          expect(video.reviews.first).to eq(Review.first)
        end
        it "associates review with current user" do
          expect(Review.first.user).to eq(User.find(session[:user_id]))
        end
      end
      context "without valid input" do
        before { post :create, review: {rating: '3 stars'}, video_id: video.id }
        it "renders video show page" do
          expect(response).to render_template "videos/show"
        end
        it "doesn't create review" do
          expect(Review.count).to eq(0)
        end
        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          expect(assigns(:review)).to eq(video.reviews)
        end
      end
    end
    context "without authenticated users" do
      it "redirects to login page" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to login_path
      end
    end
  end
end
