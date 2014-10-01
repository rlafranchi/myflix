require 'spec_helper'
require 'pry'

describe QueueItemsController do
  describe "GET index" do
    context "with authenticated user" do
      let(:user) { Fabricate(:user) }
      before { session[:user_id] = user.id }
      it "renders index template" do
        get :index
        expect(response).to render_template(:index)
      end
      it "sets @queue_items orderd by list_order" do
        qitem1 = Fabricate(:queue_item, user: user)
        qitem2 = Fabricate(:queue_item, user: user)
        get :index
        expect(assigns(:queue_items)).to eq(QueueItem.all.order("list_order"))
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
      let(:user) { Fabricate(:user) }
      before do
        session[:user_id] = user.id
      end
      context "with valid input" do
        it "creates queue_item" do
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.count).to eq(1)
        end
        it "redirects back to queue page" do
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(response).to redirect_to my_queue_path
        end
        it "creates a queue_item associated with a video" do
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.first.video).to eq(video)
        end
        it "creates a queue_item associated with the current user" do
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.first.user).to eq(user)
        end
        it "puts the video at the last position" do
          monk = Fabricate(:video)
          Fabricate(:queue_item, video: monk, user: user)
          video = Fabricate(:video)
          post :create, video_id: video.id
          vid_qitem = QueueItem.where(video_id: video.id, user_id: user.id).first
          expect(vid_qitem.list_order).to eq(2)
        end
        it "does not add the video if it's already in the queue" do
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
    it "reorders queue_items" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user_id: user.id, list_order: 1)
      queue_item2 = Fabricate(:queue_item, user_id: user.id, list_order: 2)
      queue_item3 = Fabricate(:queue_item, user_id: user.id, list_order: 3)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.all.map(&:list_order)).to eq([1,2])
    end
  end
  describe "POST update_queue" do
    context "with authenticated users" do
      context "with valid input" do
        let(:video) { Fabricate(:video) }
        let (:user) { Fabricate(:user) }
        before do
          session[:user_id] = user.id
        end
        it "redirects back to my_queue" do
          qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 1)
          qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 2)
          post :update_queue, up_queue_items: [{id: qitem1.id, list_order: 2},{id: qitem2.id, list_order: 1}]
          expect(response).to redirect_to my_queue_path
        end
        it "saves new list_order to each queue_item" do
          qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 1)
          qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 2)
          post :update_queue, up_queue_items: [{id: qitem1.id, list_order: 2},{id: qitem2.id, list_order: 1}]
          expect(user.queue_items).to eq([qitem2,qitem1])
        end
        it "normalizes the position of the queue_items" do
          qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 2)
          qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 3)
          post :update_queue, up_queue_items: [{id: qitem1.id, list_order: 2},{id: qitem2.id, list_order: 1}]
          expect(user.queue_items.map(&:list_order)).to eq([1, 2])
        end
        it "updates rating" do
          video = Fabricate(:video)
          review1 = Fabricate(:review, user: user, video: video, rating: 1 )
          video2 = Fabricate(:video)
          review2 = Fabricate(:review, user: user, video: video2, rating: 1 )
          qitem1 = Fabricate(:queue_item, video: video, user: user, list_order: 1 )
          qitem2 = Fabricate(:queue_item, video: video2, user: user, list_order: 2 )
          post :update_queue, up_queue_items: [{id: qitem1.id, list_order: 2, rating: 2},{id: qitem2.id, list_order: 1, rating: 4}]
          expect(review2.reload.rating).to eq(4)
          expect(review1.reload.rating).to eq(2)
        end
      end
      context "with invalid input" do
        let(:video) { Fabricate(:video) }
        let (:user) { Fabricate(:user) }
        before do
          session[:user_id] = user.id
        end
        it "flashes error" do
          qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video, list_order: 1)
          qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video, list_order: 2)
          post :update_queue, up_queue_items: [{id: qitem1.id, list_order: 2.5},{id: qitem2.id, list_order: 1}]
          expect(flash).to be_truthy
        end
        it "redirects back to my_queue" do
          qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video, list_order: 1)
          qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video, list_order: 2)
          post :update_queue, up_queue_items: [{id: qitem1.id, list_order: 2.5},{id: qitem2.id, list_order: 1}]
          expect(response).to redirect_to my_queue_path
        end
        it "does not save queue_item" do
          qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video, list_order: 1)
          qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video, list_order: 2)
          post :update_queue, up_queue_items: [{id: qitem1.id, list_order: 2.5},{id: qitem2.id, list_order: 1}]
          expect(qitem1.reload.list_order).to eq(1)
          expect(qitem2.reload.list_order).to eq(2)
        end
      end
    end
    context "with unauthenticated users" do
      it "redirects to login path" do
        post :update_queue, up_queue_items: [{id: 4, list_order: 2.5},{id: 5, list_order: 1}]
        expect(response).to redirect_to login_path
      end
    end
    context "with queue items that do not belong to the current user" do
      let(:video) { Fabricate(:video) }
      it "redirects back to" do
        user = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user.id
        qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 1)
        qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 2)
        qitem3 = Fabricate(:queue_item, user_id: user2.id, video_id: video.id, list_order: 3)
        post :update_queue, up_queue_items: [{id: qitem3.id, list_order: 2},{id: qitem2.id, list_order: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "does not save other queue item" do
        user = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user.id
        qitem1 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 1)
        qitem2 = Fabricate(:queue_item, user_id: user.id, video_id: video.id, list_order: 2)
        qitem3 = Fabricate(:queue_item, user_id: user2.id, video_id: video.id, list_order: 3)
        post :update_queue, up_queue_items: [{id: qitem3.id, list_order: 2},{id: qitem2.id, list_order: 1}]
        expect(qitem1.reload.list_order).to eq(1)
        expect(qitem2.reload.list_order).to eq(2)
        expect(qitem3.reload.list_order).to eq(3)
      end
    end
  end
end
