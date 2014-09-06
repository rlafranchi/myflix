require 'spec_helper'

describe Video do
  it "should save" do
    v = Video.create(name: 'name', description: 'description' )
    expect(Video.first).to eq(v)
  end

  it "belongs to category" do
    cat = Category.create(name: 'Dramas')
    vid = Video.create(name: 'Monk', description: 'drama', categories: [cat])
    # 1:M expect(vid.category).to eq(cat)
    expect(vid.categories).to eq([cat])
  end

  # M:M association
  # it "has many categories" do

  # end

  it "requires name" do
    video = Video.create(description: 'description')
    video.save
    expect(Video.count).to eq(0)
  end

  it "requires description" do
    video = Video.create(name: 'name')
    video.save
    expect(Video.count).to eq(0)
  end
end
