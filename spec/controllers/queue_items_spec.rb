require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      before { session[:user_id] = user.id }
      it "renders index template" do
        get :index
        expect(response).to render_template(:index)
      end
      it "sets @queue_items" do
        qitem1 = Fabricate(:queue_item, user: user)
        qitem2 = Fabricate(:queue_item, user: user)
        get :index
        expect(assigns(:queue_items)).to eq(QueueItem.all)
      end
    end
    context "without authenticated user" do
      it "redirects to login_path" do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end
  describe "POST create" do
    context "with authenticated user" do
      context "with valid input" do
        it "creates queue_item" do
          session[:user_id] = Fabricate(:user).id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.count).to eq(1)
        end
        it "redirects back to queue page" do
          session[:user_id] = Fabricate(:user).id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(response).to redirect_to my_queue_path
        end
        it "creates a queue_item associated with a video" do
          session[:user_id] = Fabricate(:user).id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.first.video).to eq(video)
        end
        it "creates a queue_item associated with the current user" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.first.user).to eq(user)
        end
        it "puts the video at the last position" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          monk = Fabricate(:video)
          Fabricate(:queue_item, video: monk, user: user)
          video = Fabricate(:video)
          post :create, video_id: video.id
          vid_qitem = QueueItem.where(video_id: video.id, user_id: user.id).first
          expect(vid_qitem.list_order).to eq(2)
        end
        it "does not add the video if it's already in the queue" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          monk = Fabricate(:video)
          Fabricate(:queue_item, video: monk, user: user)
          post :create, video_id: monk.id
          expect(QueueItem.count).to eq(1)
        end

      end
#      context "without valid input" do
#        it "renders index template"
#      end
    end
    context "without authenticated user" do
      it "redirects to login_path" do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end
  describe "DELETE destroy" do
    it "should redirect to my_queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "deletes queue_item" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user_id: user.id)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    it "does not delete queue_item if current user doesn't own queue_item" do
      user = Fabricate(:user)
      user2 = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user_id: user2.id)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    it "redirects to login path if unauthenticated" do
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to login_path
    end
  end
end
