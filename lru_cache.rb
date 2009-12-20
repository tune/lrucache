# LRUCache
# 一定の数に達したら使われてない順に要素が削除されていくMapのような入れ物
class LRUCache
	attr_accessor :max_size # 最大記憶サイズ
	attr_accessor :expire   # データの有効期限(ミリ秒)

	def initialize( max_size = 10 )
    raise LRUCacheException unless max_size.is_a?(Fixnum)
		raise LRUCacheException if max_size <= 0

		@max_size = max_size
		@queue = []
		@expire = 360000
	end
    
	def max_size=(max_size)
		@max_size = max_size
		size_wipeout
	end

	# keyとvalueを関連付けて記録
	def put(key, value)
    @queue.delete_if {|v| v.has_key?(key)}
		@queue << KVS.new(key, value)
    size_wipeout
	end

	# keyに対応する値を返す
	def get(key)
		time_wipeout
		@queue.each do |v|
			if v.has_key?(key)
				@queue.delete(v)
        		v.touch
				@queue << v
				return v.value
			end
		end
		nil
	end
	
	# 最も参照されていないキーを返す
	def oldest_key
		raise LRUCacheException if @queue.first.nil?
		@queue.first.key
	end

  private

	def size_wipeout
		@queue = @queue.last(max_size)
	end

	def time_wipeout(now = Time.now)
		@queue.delete_if do |i|
			(now - i.time) * 1000 > @expire
		end
	end
	
	class KVS
		attr_reader :key, :value, :time
    
    	def initialize(key, value)
    		@key = key
    		@value = value
    		touch
		end

		def has_key?(key)
			@key == key
		end

		def touch
			@time = Time.now
		end
	end
end

# 例外クラス
class LRUCacheException < RuntimeError
end

