require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Comedies")
    category.save
    expect(Category.first).to eq(category)
  end

  it {should have_many(:videos)}

  describe "#recent_videos" do
    it "returns array of videos ordered by created at"
    it "returns all videos if there are less than six videos"
    it "returns six videos if there are six or more"
    it "returns empyt array if no videos"
  end
end
