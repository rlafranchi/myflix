require 'spec_helper'

describe Video do
  it "should save" do
    v = Video.create(name: 'name', description: 'description' )
    expect(Video.first).to eq(v)
  end
  it {should belong_to(:category)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:description)}
  it {should have_many(:reviews).order("created_at DESC")}

  describe "search_by_name" do
    it "returns empty array if no match" do
      futurama = Video.create(name: "Futurama", description: "Space travel")
      back_to_future = Video.create(name: "Back to the Future", description: "time travel")
      expect(Video.search_by_name("hello")).to eq([])
    end
    it "returns an array of one video for an exact match" do
      futurama = Video.create(name: "Futurama", description: "Space travel")
      back_to_future = Video.create(name: "Back to the Future", description: "time travel")
      expect(Video.search_by_name("Futurama")).to eq([futurama])
    end
    it "returns array of one video for a partial match" do
      futurama = Video.create(name: "Futurama", description: "Space travel")
      back_to_future = Video.create(name: "Back to the Future", description: "time travel")
      expect(Video.search_by_name("urama")).to eq([futurama])
    end
    it "returns array of multiple vidoes for multiple matches" do
      futurama = Video.create(name: "Futurama", description: "Space travel")
      back_to_future = Video.create(name: "Back to the Future", description: "time travel", created_at: 1.day.ago)
      expect(Video.search_by_name("Futur")).to eq([futurama, back_to_future])
    end
    it "searches for empy string" do
      futurama = Video.create(name: "Futurama", description: "Space travel")
      back_to_future = Video.create(name: "Back to the Future", description: "time travel", created_at: 1.day.ago)
      expect(Video.search_by_name("")).to eq([])
    end
  end

  describe "#average_rating" do
    it "should return average of ratings" do
      rev1 = Fabricate(:review, rating: 1)
      rev2 = Fabricate(:review, rating: 2)
      rev3 = Fabricate(:review, rating: 3)
      vid = Fabricate(:video, reviews: [rev1, rev2, rev3])
      expect(vid.average_rating).to eq(2.0)
    end
  end
end
