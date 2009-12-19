class LRUCache
	attr_reader :size

	def initialize( size )
		raise LRUCacheException if size == nil
		raise LRUCacheException if size <= 0

		@size = size
		@table = []
	end

	# keyとvalueを関連付けて記録
	def put(key, value)
		@table << {key => value}
		
		if @table.size > size then
			@table.shift
		end
	end

	# keyに対応する値を返す
	def get(key)
		@table.each do |element|
			if element.has_key?(key)
				@table.delete(element)
				@table << element
				return element[key]
			end
		end
	    return nil
	end
	
	# 最も参照されていないキーを返す
	def last_recently_used
		@table[0].keys[0]
	end
end

class LRUCacheException < RuntimeError
end

