require 'spec_helper'

describe Relationship do
  it { should belong_to(:leader)}
  it { should belong_to(:follower)}
end
