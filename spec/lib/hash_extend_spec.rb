require './lib/hash_extend'

describe Hash do
  subject { { a: {b: 1}, b: 2 } }
  describe '#stealth_delete!' do
    it 'returns the pre-delete hash' do
      subject.stealth_delete!(:b).should == subject
    end

    it 'deletes a key' do
      subject.stealth_delete!(:b)
      subject.should_not have_key(:b)
    end
  end

  describe '#map_values!' do
    it 'modifies values from hash through block' do
      subject.map_values! { 1 }
      subject.should == { a: 1, b: 1 }
    end

    it 'returns modified hash' do
      subject.map_values! { 2 }.should == { a: 2, b: 2 }
    end
  end
end
