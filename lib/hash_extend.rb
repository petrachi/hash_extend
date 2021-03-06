require "hash_extend/version"

class Hash
  # delete key(s) but return self instead of deleted value
  def stealth_delete! *keys
    warn "WARNING : method 'stealth_delete!' is deprecated and will be deleted in version X.Y - Use 'except!' to fit Rails' ActiveSupport"
    except! keys
  end
  
  def stealth_delete *keys
    warn "WARNING : method 'stealth_delete' is deprecated and will be deleted in version X.Y - Use 'except' to fit Rails' ActiveSupport"
    except keys
  end
  
  
  
  # modify values from hash through block
  def map_values!
    self.each do |key, value|
      self[key] = yield value
    end
  end
  
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
  
  
  # delete severals keys in one time
  def delete_many *keys
    keys.map{ |key| delete(key) }
  end
  
  
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
    
  # something like #keep_if, but instead of block, pass collection of keys to select
  def select_by! *keys
    warn "WARNING : method 'select_by!' is deprecated and will be deleted in version 1.3 - Use 'extract!' to fit Rails's ActiveSupport"
    self.delete_if{ |field, _| !keys.include? field.to_sym }
  end
  
  def select_by *keys
    warn "WARNING : method 'select_by' is deprecated and will be deleted in version 1.3 - Use 'slice' to fit Rails's ActiveSupport"
    slice *keys
  end
  
  unless method_defined? :extract!
    def extract! *keys
      hash = {}
      keys.each {|key| hash[key] = delete(key) }
      hash
    end
  end
  
  # duplicate method without self modification
  [:map_values, :compact].each do |method_name|
    
    unless method_defined? method_name
    
      define_method method_name do |*args, &block|
        hash = self.dup
        eval "hash.#{ method_name }! *args, &block"
        return hash
      end
    
    end
    
  end
  
end
