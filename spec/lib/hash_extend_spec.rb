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
end
