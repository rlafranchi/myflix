require 'spec_helper'

describe Video do
  it "should save" do
    v = Video.create(name: 'name', description: 'description' )
    v.save
    Video.first.name.should == 'name'
  end
end
