require "hash_extend/version"

class Hash

  # ?> {1=>1, 2=>2}.stealth_delete(1)
  #   => {2=>2}
  # delete key(s) but return self instead of deleted value
  def stealth_delete! *keys
    keys.each do |key|
      delete key
    end
    return self
  end
  
  
  # ?> {1=>1, 2=>2}.map_values{ |v| v**2 }
  #   => {1=>1, 2=>4}
  # modify values fro hash through block
  def map_values!
    self.each do |key, value|
      self[key] = yield value
    end
  end
  
  # ?> {1=>1, 2=>2}.map_keys{ |k| k.to_s }
  #   => {"2"=>2, "1"=>1}
  # modify keys from hash through block
  def map_keys
    self.inject({}) do |hash, (key, value)|
      hash[yield key] = value; hash
    end
  end
  
  def map_keys! &block
    to_map = self.dup
    self.clear.merge! to_map.map_keys &block
  end
  
  
  # ?> h = Hash[:un, 1, :deux, 2, :trois, 3]
  #   => {:un=>1, :deux=>2, :trois=>3}
  # ?> h.delete_many(:un, :trois)
  #   => [1, 3]
  # ?> h
  #   => {:deux=>2}
  #  
  # ?> h.delete_many(:six)
  #   => [nil]
  # delete severals keys in one time
  def delete_many *keys
    keys.map{ |key| self.delete(key) }
  end
  
  
  # ?> insert("valeur", Hash.new, :key_one, :key_two, :key_wi)
  #   => {:key_one=>{:key_two=>{:key_wi=>"valeur"}}}
  # insert a value trough severals "levels" of hashs
  def insert value, *keys
    if keys.size > 1
      shifted = keys.shift
      
      self[shifted] ||= Hash.new
      self[shifted] = self[shifted].insert value, *keys
    else
      self[keys.first] = value
    end
    
    self
  end
  
  # ?> {:un=>1, :deux=>2, :trois=>3, :quatre=>nil, :cinq=>[]}.compact!
  #   => {:cinq=>[], :un=>1, :deux=>2, :trois=>3}
  # ?> {:un=>1, :deux=>2, :trois=>3, :quatre=>nil, :cinq=>[]}.compact!(:with=>:blank?)
  #   => {:un=>1, :deux=>2, :trois=>3}
  # ?> {:un=>1, :deux=>2, :trois=>3, :quatre=>nil, :cinq=>[]}.compact!(:with=>"is_a?(Fixnum)")
  #   => {:quatre=>nil, :cinq=>[]}
  # allow to compact (like Array), default on value.nil?
  def compact! options = Hash.new
    compare = options.delete(:compare) || :value
    raise ArgumentError, ":compare option must be in %w{key value}" unless [:key, :value].include? compare.to_sym
    
    if (with = options.delete :with)
      self.each do |key, value|
        self.delete(key) if eval "#{ compare }.#{ with }"
      end
      
    else
      self.each do |key, value|
        self.delete(key) if eval "#{ compare }.nil?"
      end
    end
    
    self
  end
  
  
  # ?> {:action=>"index", :controller=>"home", :id=>"42", :firstname=>"thomas", :name=>"petrachi"}.select_from_collection! [:id, :firstname, :name]
  #   => {:firstname=>"thomas", :name=>"petrachi", :id=>"42"}
  # something like #keep_if, but instead of block, pass collection of keys to select
  def select_by! collection, *args, &block
    self.keep_if{ |field, _| collection.include? field.to_sym }  
  end
  
  
  # duplicate method without self modification
  [:stealth_delete, :map_values, :compact, :select_by].each do |method_name|
    define_method method_name do |*args, &block|
      hash = self.dup
      eval "hash.#{ method_name }! *args, &block"
      return hash
    end
  end
  
end
