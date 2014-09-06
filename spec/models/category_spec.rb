require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Comedies")
    category.save
    expect(Category.first).to eq(category)
  end

  it {should have_many(:videos)}
end
