class LRUCache
	attr_reader :size

	def initialize( size )
		raise LRUCacheException if size == nil
		raise LRUCacheException if size <= 0

		@size = size
		@table = []
	end

	# key��value���֘A�t���ċL�^
	def put(key, value)
		@table << {key => value}
		
		if @table.size > size then
			@table.shift
		end
	end

	# key�ɑΉ�����l��Ԃ�
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
	
	# �ł��Q�Ƃ���Ă��Ȃ��L�[��Ԃ�
	def last_recently_used
		@table[0].keys[0]
	end
end

class LRUCacheException < RuntimeError
end

