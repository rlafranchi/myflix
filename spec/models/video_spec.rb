require 'spec_helper'

describe Video do
  it "should save" do
    v = Video.create(name: 'name', description: 'description' )
    expect(Video.first).to eq(v)
  end
end
