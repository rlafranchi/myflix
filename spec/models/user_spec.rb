require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:name) }
  it { should have_many(:queue_items).order("list_order") }
  it { should have_many(:reviews).order("created_at DESC")}
  it { should have_many(:following_relationships) }
  it { should have_many(:leading_relationships) }
  it { should have_many(:invitations) }

  describe "#queued_video?" do
    it "should return true when user adds video to queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end
    it "should return false if user has queued video already" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be false
    end
  end

  describe "#queue_items_present?" do
    it "should return true when there are queue_items" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queue_items_present?).to be true
    end
    it "should return false when there are no queue items" do
      user = Fabricate(:user)
      expect(user.queue_items_present?).to be false
    end
  end

  describe "#generate token" do
    it "generates a token for the user" do
      user = Fabricate(:user)
      expect(user.token).to be_present
    end
  end
end
