class LRUCache
	attr_reader :max_size

	def initialize( max_size )
		raise LRUCacheException if max_size == nil
		raise LRUCacheException if max_size <= 0

		@max_size = max_size
		@queue = []
	end

	# keyとvalueを関連付けて記録
	def put(key, value)
		@queue << {key => value}
		
		if @queue.size > max_size then
			@queue.shift
		end
	end

	# keyに対応する値を返す
	def get(key)
		@queue.each do |element|
			if element.has_key?(key)
				@queue.delete(element)
				@queue << element
				return element[key]
			end
		end
	    return nil
	end
	
	# 最も参照されていないキーを返す
	def last_recently_used
		@queue[0].keys[0]
	end
end

class LRUCacheException < RuntimeError
end

