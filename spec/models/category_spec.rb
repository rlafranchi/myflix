require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Comedies")
    category.save
    expect(Category.first).to eq(category)
  end

  it {should have_many(:videos)}

  describe "#recent_videos" do
    it "returns array of videos ordered by created at" do
      category = Category.create(name: "comedies")
      family_guy = Video.create(name: "Family Guy", description: "peter griffin", categories: [category])
      south_park = Video.create(name: "South Park", description: "cartman", categories: [category], created_at: 1.day.ago)
      expect(category.recent_videos).to eq([family_guy, south_park])
    end
    it "returns all videos if there are less than six videos" do
      category = Category.create(name: "comedies")
      family_guy = Video.create(name: "Family Guy", description: "peter griffin", categories: [category])
      south_park = Video.create(name: "South Park", description: "cartman", categories: [category], created_at: 1.day.ago)
      expect(category.recent_videos.count).to eq(category.videos.count)
    end
    it "returns six videos if there are more" do
      category = Category.create(name: "comedies")
      7.times {Video.create(name: 'Vid', description: 'desc', categories: [category])}
      expect(category.recent_videos.count).to eq(6)
    end
    it "returns empyt array if no videos" do
      category = Category.create(name: "comedies")
      expect(category.recent_videos).to eq([])
    end
  end
end
