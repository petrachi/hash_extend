# HashExtend

Extend ruby Hash. No override.

## Support

Validate for Ruby 1.9.3 and Ruby ree-1.8.7

## Installation

Add this line to your application's Gemfile:

    gem 'hash_extend'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_extend

## Usage

### stealth_delete -- Deprecated -> Use except

method 'stealth_delete' is deprecated and will be deleted in version 2.4 - Use 'except' to fit Rails's ActiveSupport

--

Delete key(s) passed by, but return the hash instead of the deleted value

```ruby
	stealth_delete! *keys
	stealth_delete *keys
```

Demo

```ruby
	{:one=>1, :two=>2, :three=>3}.stealth_delete :one
	#=> {:two=>2, :three=>3}
	
	{:one=>1, :two=>2, :three=>3}.stealth_delete :one, :three
	#=> {:two=>2}
	
	{:one=>1, :two=>2, :three=>3}.stealth_delete :four
	#=> {:one=>1, :two=>2, :three=>3}
	
	{:one=>1, :two=>2, :three=>3}.stealth_delete :one, :four
	#=> {:two=>2, :three=>3}
```

Code

```ruby	
	def stealth_delete! *keys
	  	keys.each do |key|
	    	delete key
	  	end
	  	return self
	end
```


### map_values

Update values through block

```ruby
	map_values!
	map_values
```

Demo

```ruby
	# square values
	{:one=>1, :two=>2, :three=>3}.map_values{ |value| value ** 2 }
	#=> {:one=>1, :two=>4, :three=>9}
```

Code

```ruby	
	def map_values!
  		self.each do |key, value|
    		self[key] = yield value
  		end
	end
```


### map_keys

Update keys through block

```ruby
	map_keys!
	map_keys
```

Demo

```ruby
	{"one"=>1, "two"=>2, "three"=>3}.map_keys(&:to_sym)
	#=> {:one=>1, :two=>2, :three=>3}
```

Code

```ruby	
	def map_keys
    	self.inject({}) do |hash, (key, value)|
      		hash[yield key] = value; hash
    	end
	end
	
	def map_keys! &block
    	to_map = self.dup
    	self.clear.merge! to_map.map_keys &block
  	end
```

Perfomances : Generaly, use the "!" is faster than the "no self modification" methods. Cause the last one used to "dup" the object. As we can't modify keys hash during iteration, here it's the reverse.


### delete_many

Delete severals keys in one

Demo

```ruby
	h = Hash[:one, 1, :two, 2, :three, 3]		#=> {:one=>1, :two=>2, :three=>3}
	h.delete_many(:one, :three)					#=> [1, 3]
	h											#=> {:two=>2}
	
	h.delete_many(:six)							#=> [nil]
```

Code

```ruby	
	def delete_many *keys
  		keys.map{ |key| self.delete(key) }
	end
```

--

FYI : ActiveSupport provide method 'slice'.

```ruby
	h = Hash[:one, 1, :two, 2, :three, 3]		#=> {:one=>1, :two=>2, :three=>3}
	h.slice(:one, :three)						#=> {:three=>3, :one=>1}
	h											#=> {:one=>1, :two=>2, :three=>3}
	
	h.slice(:six)								#=> {}
```

WARNING : slice! has not the same behavior. Check out ActiveSupport guides for more information : http://guides.rubyonrails.org/active_support_core_extensions.html

--

FYI : Rails 3's ActiveSupport provide method 'extract!'. (this gem provide method 'extract!' for Rails < 3)

```ruby
	h = Hash[:one, 1, :two, 2, :three, 3]		#=> {:one=>1, :two=>2, :three=>3}
	h.extract!(:one, :three)					#=> {:one=>1, :three=>3}
	h											#=> {:two=>2}
	
	h.extract!(:six)							#=> {:six=>nil}
```

### insert

Insert a value through descendance of keys (hash in hash)

Demo

```ruby
	h = Hash.new		#=> {}
	h.insert(12, :calendar, :gregorian, :months)
	#=> {:calendar => {:gregorian => {:months => 12}}}

	h.insert(13, :calendar, :lunar, :months)
	#=> {:calendar => {:gregorian => {:months => 12}, :lunar => {:months => 13}}}
```

Code

```ruby	
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
```


### compact

Allow to compact hash just like arrays. Well, you can check nil, or black, or whatever you want on keys OR values

```ruby
	compact! options = Hash.new
	compact options = Hash.new
```

Arguments : ':compare' must be in %w{key value}, default is :value
Arguments : ':with' is recommended in %w{blank? empty?}, default is :nil?

Demo

```ruby
	{:one=>1, :two=>2, :three=>3, :four=>nil, :five=>[]}.compact!
	#=> {:five=>[], :one=>1, :two=>2, :three=>3}

	{:one=>1, :two=>2, :three=>3, :four=>nil, :five=>[]}.compact!(:with=>:blank?)
	#=> {:one=>1, :two=>2, :three=>3}
	
	# for the perverts ones
	{:one=>1, :two=>2, :three=>3, :four=>nil, :five=>[]}.compact!(:with=>"is_a?(Fixnum)")
	#=> {:four=>nil, :five=>[]}
	
	# And for the ones who REALLY care about memory
	{:one=>1, "two"=>2, "three"=>3, "four"=>nil, :five=>[]}.compact!(:compare => :key, :with=>"is_a?(String)")
	#=> {:one=>1, :five=>[]}
```

Code

```ruby	
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
```


### select_by -- Deprecated -> Use except

method 'select_by' is deprecated and will be deleted in version 2.4 - Use 'slice' to fit Rails's ActiveSupport

method 'select_by!' is deprecated and will be deleted in version 2.4 - Use 'extract!' to fit Rails's ActiveSupport

--

Select into hash from a collection of keys. Usefull to select correct params after a form.

```ruby
	select_by! *keys
	select_by *keys
```

Demo

```ruby
	{:one=>1, :two=>2, :three=>3, :four=>4}.select_by :one, :three
	#=> {:one=>1, :three=>3}
	
	{:one=>1, :two=>2, :three=>3, :four=>4}.select_by :one, :six
	#=> {:one=>1}
	
	{:one=>1, :two=>2, :three=>3, :four=>4}.select_by :six, :seven
	#=> {}
```

Code

```ruby	
	def select_by! *keys
  		self.delete_if{ |field, _| !keys.include? field.to_sym }  
	end
```

### extract -- Only for Rails < 3

Select into hash from a collection of keys

```ruby
	extract! *keys
```

Demo

```ruby
	h = Hash[:one, 1, :two, 2, :three, 3]				#=> {:two=>2, :three=>3, :one=>1}
	h.extract! :one, :three								#=> {:one=>1, :three=>3}
	h													#=> {:two=>2}
	
	{:one=>1, :two=>2, :three=>3, :four=>4}.extract! :one, :six
	#=> {:one=>1, :six=>nil}
	
	{:one=>1, :two=>2, :three=>3, :four=>4}.extract! :six, :seven
	#=> {:six=>nil, :seven=>nil}
```

Code

```ruby	
	def extract! *keys
  		hash = {}
  		keys.each {|key| hash[key] = delete(key) }
  		hash
	end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
