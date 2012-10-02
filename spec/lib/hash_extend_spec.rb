require './lib/hash_extend'

describe Hash do
  subject { { a: {b: 1}, b: 2 } }
  let!(:old) { subject }
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

  describe '#map_keys' do
    it 'modifies keys from hash through block' do
      subject.map_keys { 2 }.should == { 2 => 2 }
    end

    it 'does not modify the hash' do
      subject.map_keys { 2 }
      subject.should == old
    end
  end
  
  describe '#map_keys!' do
    it 'modifies the hash changing keys through block' do
      subject.map_keys! { 2 }
      subject.should == { 2 => 2 }
    end
  end
  
  describe '#delete_many' do
    it 'can delete one key' do
      subject.delete_many(:a)
      subject.should_not have_key(:a)
      subject.should have_key(:b)
    end

    it 'can delete many keys' do
      subject.delete_many(:a, :b)
      subject.should_not have_key(:a)
      subject.should_not have_key(:b)
    end
  end
end
