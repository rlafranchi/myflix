require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Comedies")
    category.save
    expect(Category.first).to eq(category)
  end

  it "has_many videos" do
    comedies = Category.create(name: "Comedies")
    south_park = Video.create(name: "South Park", description: "Cartoon Comedy", categories: [comedies])
    family_guy = Video.create(name: "Family Guy", description: "Created by Seth Mcfarlane", categories: [comedies])
    expect(comedies.videos).to eq([south_park,family_guy])
  end

  # it "belongs to many videos" do

  # end
end
