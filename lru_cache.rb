# LRUCache
# ���̐��ɒB������g���ĂȂ����ɗv�f���폜����Ă���Map�̂悤�ȓ��ꕨ
class LRUCache
	attr_accessor :max_size # �ő�L���T�C�Y
	attr_accessor :expire   # �f�[�^�̗L������(�~���b)

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

	# key��value���֘A�t���ċL�^
	def put(key, value)
    @queue.delete_if {|v| v.has_key?(key)}
		@queue << KVS.new(key, value)
    size_wipeout
	end

	# key�ɑΉ�����l��Ԃ�
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
	
	# �ł��Q�Ƃ���Ă��Ȃ��L�[��Ԃ�
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

# ��O�N���X
class LRUCacheException < RuntimeError
end

