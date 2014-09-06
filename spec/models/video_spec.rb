require 'spec_helper'

describe Video do
  it "should save" do
    v = Video.create(name: 'name', description: 'description' )
    expect(Video.first).to eq(v)
  end
  it {should have_many(:categories)}
  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:description)}
end
