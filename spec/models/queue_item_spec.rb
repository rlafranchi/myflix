require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:list_order).only_integer }
  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, name: "Mank")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_name).to eq("Mank")
    end
  end

  describe "#rating" do
    it "reutrns the rating from the review when review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 4 )
      qitem = Fabricate(:queue_item, video: video, user: user )
      expect(QueueItem.first.rating).to eq(4)
    end
    it "reutrns nil from the review when review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      # review = Fabricate(:review, video: video, user: user, rating: 4 )
      qitem = Fabricate(:queue_item, video: video, user: user )
      expect(QueueItem.first.rating).to eq(nil)
    end
  end

  describe "#rating=" do
    it "changes rating of the review if it is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      qitem = Fabricate(:queue_item, user: user, video: video )
      qitem.rating = 3
      expect(Review.first.rating).to eq(3)
    end
    it "clears rating of the review if not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      qitem = Fabricate(:queue_item, user: user, video: video )
      qitem.rating = nil
      expect(Review.first.rating).to be_nil
    end
    it "creates a review if no review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      # review = Fabricate(:review, user: user, video: video, rating: 4)
      qitem = Fabricate(:queue_item, user: user, video: video )
      qitem.rating = 4
      expect(Review.first.rating).to eq(4)
    end
  end

  describe "#category_name" do
    it "returns the name of the queue item's video category name" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      qitem = Fabricate(:queue_item, video: video)
      expect(qitem.category_name).to eq(category.name)
    end
  end

  describe "#category" do
    it "returns category of queueitem" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      qitem = Fabricate(:queue_item, video: video)
      expect(qitem.category).to eq(category)
    end
  end
end
